require 'action_sms/connection_adapters/abstract_adapter'
require 'uri'

module ActionSms
  class Base
    def self.sms_global_connection(config) #:nodoc:
      return ConnectionAdapters::SMSGlobalAdapter.new(logger, config)
    end
  end

  module ConnectionAdapters
    # All the concrete gateway adapters follow the interface laid down in this
    # class.  You can use this interface directly by borrowing the gateway
    # connection from the Base with Base.connection.
    class SMSGlobalAdapter < AbstractAdapter
      SERVICE_HOST = "http://smsglobal.com.au"
      SERVICE_PATH = "http-api.php"

      def initialize(logger = nil, config = {}) #:nodoc:
        super(logger)
        @config = config.dup
        @service_url = URI.join(SERVICE_HOST, SERVICE_PATH)
        @service_url.scheme = config[:use_ssl] ? "https" : "http"
      end

      def message_id(data)
        sms_global_message_id_prefix = "SMSGlobalMsgID:"
        if data.is_a?(Hash)
          message_id = data["msgid"]
          sms_global_message_id_prefix + message_id if message_id
        elsif data.is_a?(String)
          match = /#{sms_global_message_id_prefix}\d+/.match(data)
          match[0] if match
        end
      end

      def status(delivery_receipt)
        delivery_receipt["dlrstatus"]
      end

      def message_text(params)
        params["msg"]
      end

      def sender(params)
        params["from"]
      end

      def authenticate(params)
        params.delete("userfield") == @config[:authentication_key]
      end

      def delivery_request_successful?(gateway_response)
        gateway_response =~ /^OK/
      end

      def deliver(sms)
        params = {
          :action   => 'sendsms',
          :user     => @config[:user],
          :password => @config[:password],
          :maxsplit => 3,
          :from     => sms.respond_to?(:from) ? sms.from : "reply2email",
          :to       => sms.recipient,
          :text     => (sms.body || "")
        }
        if sms.respond_to?(:userfield)
          userfield = sms.userfield
        elsif @config[:authentication_key]
          userfield = @config[:authentication_key]
        end
        params.merge!(
          :userfield => userfield
        ) if userfield
        send_http_request(@service_url.to_s, params)
      end
    end
  end
end


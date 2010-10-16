require 'action_sms/connection_adapters/abstract_adapter'

module ActionSms
  class Base
    def self.sms_global_connection(config) #:nodoc:
      if config[:environment].to_s == "test"
        test_helper = File.expand_path(File.dirname(__FILE__) + '/test_helpers/sms_global')
        if File.exists?("#{test_helper}.rb")
          require test_helper
          ConnectionAdapters::SMSGlobalAdapter.class_eval do
            include TestHelpers::SMSGlobal
          end
        end
      end
      ConnectionAdapters::SMSGlobalAdapter.new(config)
    end
  end

  module ConnectionAdapters
    # All the concrete gateway adapters follow the interface laid down in this
    # class.  You can use this interface directly by borrowing the gateway
    # connection from the Base with Base.connection.
    class SMSGlobalAdapter < AbstractAdapter
      require 'uri'

      SERVICE_URL = "http://smsglobal.com.au/http-api.php"

      def initialize(config = {}) #:nodoc:
        @config = config
      end

      def authentication_key=(value)
        @config[:authentication_key] = value
      end

      def authenticiation_key
        @config[:authentication_key]
      end

      def use_ssl=(value)
        @config[:use_ssl] = value
      end

      def use_ssl
        @config[:use_ssl]
      end

      def service_url
        service_uri = URI.parse(SERVICE_URL)
        service_uri.scheme = @config[:use_ssl] ? "https" : "http"
        service_uri.to_s
      end

      def message_id(data)
        sms_global_message_id_prefix = "SMSGlobalMsgID:"
        if data.is_a?(Hash)
          message_id = data["msgid"]
          sms_global_message_id_prefix + message_id if message_id
        elsif data.is_a?(String)
          match = /#{sms_global_message_id_prefix}\s*(\d+)/.match(data)
          sms_global_message_id_prefix + $1 if $1
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
        params["authentication_key"] == @config[:authentication_key] ?
          params.delete("authentication_key") : nil
      end

      def delivery_request_successful?(gateway_response)
        gateway_response =~ /^OK/
      end

      def deliver(sms, options = {})
        params = {
          :action   => 'sendsms',
          :user     => @config[:user],
          :password => @config[:password],
          :maxsplit => @config[:maxsplit] || "19",
          :from     => sms.respond_to?(:from) ? sms.from : "reply2email",
          :to       => sms.recipient,
          :text     => (sms.body || "")
        }
        params.merge!(
          :userfield => sms.userfield
        ) if sms.respond_to?(:userfield)
        send_http_request(service_url, params)
      end
    end
  end
end


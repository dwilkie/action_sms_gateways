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

      def deliver(sms)
        params = {
          :action   => 'sendsms',
          :user     => @config[:user],
          :password => @config[:password],
          :maxsplit => 3,
          :from => (sms.from || "reply2email"),
          :to       => sms.recipients,
          :text     => sms.body
        }
        send_http_request(@service_url.to_s, params)
      end
    end
  end
end


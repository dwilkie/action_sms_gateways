require 'action_sms/connection_adapters/abstract_adapter'

module ActionSms
  class Base
    def self.tropo_connection(config) #:nodoc:
      if config[:environment].to_s == "test"
        test_helper = File.expand_path(File.dirname(__FILE__) + '/test_helpers/tropo')
        if File.exists?("#{test_helper}.rb")
          require test_helper
          ConnectionAdapters::TropoAdapter.class_eval do
            include TestHelpers::Tropo
          end
        end
      end
      ConnectionAdapters::TropoAdapter.new(config)
    end
  end

  module ConnectionAdapters
    # All the concrete gateway adapters follow the interface laid down in this
    # class.  You can use this interface directly by borrowing the gateway
    # connection from the Base with Base.connection.
    class TropoAdapter < AbstractAdapter
      require 'uri'
      require 'tropo_message'

      attr_reader :service_url

      SERVICE_HOST = "http://api.tropo.com"
      SERVICE_PATH = "1.0/sessions"

      def initialize(config = {}) #:nodoc:
        @config = config.dup
        service_uri = URI.join(SERVICE_HOST, SERVICE_PATH)
        service_uri.scheme = config[:use_ssl] ? "https" : "http"
        @service_url = service_uri.to_s
      end

      # message_id and status are for text message delivery receipts only
      # Tropo does not *yet* send text message delivery receipts, so these
      # two methods are here for testing purposes
      def message_id(data)
        data.is_a?(Hash) ? data["message_id"] : data
      end

      def status(delivery_receipt)
        delivery_receipt["status"]
      end

      def delivery_request_successful?(gateway_response)
        gateway_response =~ /\<success\>true\<\/success\>/
      end

      def message_text(params)
        session(params)["initial_text"]
      end

      def sender(params)
        session(params)["from"]["id"]
      end

      def authenticate(params)
        params.delete("authentication_key") == @config[:authentication_key]
      end

      def deliver(sms)
        tropo_message = Tropo::Message.new
        tropo_message.to = sms.recipient
        tropo_message.text = sms.body || ""
        tropo_message.from = sms.from if sms.respond_to?(:from)
        tropo_message.token = @config[:outgoing_token]
        puts tropo_message.request_xml
        send_http_request(@service_url, tropo_message.request_xml)
      end

      private
        def session(params)
          params["session"]
        end
    end
  end
end


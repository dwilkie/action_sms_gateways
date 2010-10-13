module TestHelpers
  module SMSGlobal
    def incoming_sms_factory_params(options = {})
      options[:message] ||= "Endia kasdf ofeao"
      options[:to]      ||= "61447100308"
      options[:from]    ||= "61447100399"
      options[:date]    ||= "2010-05-13 23:59:11"
      params = {
        "to" => options[:to],
        "from" => options[:from],
        "msg"=> options[:message],
        "date" => options[:date]
      }
      params.merge!("userfield" => @config[:authentication_key]) unless options[:reply] == false
      params
    end

    def sample_delivery_response(options = {})
      options[:failure] ? "ERROR: No action requested" : "OK: 0; Sent queued message ID: 86b1a945370734f4 SMSGlobalMsgID:6942744494999745"
    end

    def sample_message_id
      "SMSGlobalMsgID:694274449499974"
    end

    def delivery_receipt_factory_params(options = {})
      options[:message_id] ||= '6942744494999745'
      options[:status] ||= 'DELIVRD'
      options[:error] ||= '000'
      options[:date] ||= '1005132312'
      {
        'msgid'=> options[:message_id],
        'dlrstatus'=> options[:status],
        'dlr_err'=> options[:error],
        'donedate'=> options[:date]
      }
    end
  end
end


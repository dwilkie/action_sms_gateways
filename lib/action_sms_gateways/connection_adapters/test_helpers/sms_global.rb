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
  end
end


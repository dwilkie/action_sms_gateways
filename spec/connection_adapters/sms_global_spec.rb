require 'spec_helper'

describe ActionSms::ConnectionAdapters::SMSGlobalAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::SMSGlobalAdapter.new }
  describe "#message_id" do
    context "argument is a String" do
      context "and includes an SMSGlobal message id" do
        it "should return the message id with an SMSGlobal prefix" do
          adapter.message_id("Blah blah blah SMSGlobalMsgID:  123556blah").should == "SMSGlobalMsgID:123556"
        end
      end
      context "but does not include an SMSGlobal message id" do
        it "should return nil" do
          adapter.message_id("Blah blah blah SMSGlobalMsID:  123556blah").should be_nil
        end
      end
    end
  end

  describe "#service_url" do
    context "using ssl" do
      before do
        adapter.use_ssl = true
      end
      it "should return the service url as https" do
        URI.parse(adapter.service_url).scheme.should == "https"
      end
    end
    context "without using ssl" do
      it "should return the service url as http" do
        URI.parse(adapter.service_url).scheme.should == "http"
      end
    end
  end

  describe "#status" do
    let (:delivery_receipt) { {} }
    context "given a valid delivery receipt" do
      before do
        delivery_receipt["dlrstatus"] = "ANYTHING"
      end
      it "should return the delivery status" do
        adapter.status(delivery_receipt).should_not be_nil
      end
    end
    context "given a invalid delivery receipt" do
      it "should return nil" do
        adapter.status(delivery_receipt).should be_nil
      end
    end
  end

  describe "#message_text" do
    let (:request_params) { {} }
    context "given valid incoming message request params" do
      before do
        request_params["msg"] = "ANYTHING"
      end
      it "should return the message" do
        adapter.message_text(request_params).should_not be_nil
      end
    end
    context "given invalid incoming message request params" do
      it "should return nil" do
        adapter.message_text(request_params).should be_nil
      end
    end
  end

  describe "#sender" do
    let (:request_params) { {} }
    context "given valid incoming message request params" do
      before do
        request_params["from"] = "ANYTHING"
      end
      it "should return the message" do
        adapter.sender(request_params).should_not be_nil
      end
    end
    context "given invalid incoming message request params" do
      it "should return nil" do
        adapter.sender(request_params).should be_nil
      end
    end
  end

  describe "#authenticate" do
    let (:request_params) { {} }
    context "the incoming message's 'userfield' value is the same as the adapter's authentication key" do
      before do
        adapter.authentication_key = "my_secret_key"
        request_params["userfield"] = "my_secret_key"
      end
      it "should not be nil" do
        adapter.authenticate(request_params).should_not be_nil
      end
      it "should remove the key from the request params hash" do
        adapter.authenticate(request_params)
        request_params["userfield"].should be_nil
      end
    end
    context "the incoming message's 'userfield' value is different from the adapter's authentication key" do
      before do
        request_params["userfield"] = "invalid key"
      end
      it "should return nil" do
        adapter.authenticate(request_params).should be_nil
      end
      it "should not remove the key from the request params hash" do
        adapter.authenticate(request_params)
        request_params["userfield"].should_not be_nil
      end
    end
  end

  describe "#delivery_request_successful?" do
    context "the gateway response was successful" do
      let (:delivery_response) {
        "OK: 0; Sent queued message ID: 86b1a945370734f4 SMSGlobalMsgID: 6942744494999745"
      }
      it "should not return nil" do
        adapter.delivery_request_successful?(delivery_response).should_not be_nil
      end
    end
    context "the gateway response was not successful" do
      let (:delivery_response) { "ERROR: No action requested" }
      it "should return nil" do
        adapter.delivery_request_successful?(delivery_response).should be_nil
      end
    end
  end

  describe "#deliver" do
    let(:sms) { mock("sms").as_null_object }
    before do
      adapter.stub!(:send_http_request)
    end
    context "an authentication key has been set" do
      before do
        adapter.authentication_key = "my_secret_key"
      end
      context "sms responds to 'userfield'" do
        before do
          sms.stub!(:userfield).and_return("custom userfield")
        end
        it "should send the delivery request with sms' userfield" do

        end
      end
    end
  end
end


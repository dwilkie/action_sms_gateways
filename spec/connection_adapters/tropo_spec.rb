require 'spec_helper'

describe ActionSms::ConnectionAdapters::TropoAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::TropoAdapter.new }

  describe "#deliver" do
    context ":filter_response => true" do
      it "should not return the token" do
        sms = mock("sms").as_null_object
        adapter.stub!(:send_http_request).and_return(
          "<session><success>true</success><token>my_secret_token</token></session>"
        )
        adapter.deliver(
          sms, :filter_response => true
          ).should == "<session><success>true</success></session>"
      end
    end
  end

  describe "#delivery_request_successful?" do
    it "add test here" do
      pending
    end
  end

  describe "#message_id" do
    it "should not return nil" do
      adapter.message_id("any text").should be_nil
    end
  end

  describe "#service_url" do
    it "should be the tropo sessions url" do
      adapter.service_url.should == "http://api.tropo.com/1.0/sessions"
    end
  end

  describe "#status" do
    it "should not return nil" do
      adapter.status({"status" => "success"}).should be_nil
    end
  end
end


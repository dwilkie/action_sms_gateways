require 'spec_helper'

describe ActionSms::ConnectionAdapters::SMSGlobalAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::SMSGlobalAdapter.new }
  describe "#message_id" do
    context "when passing in a string:" do
      it "'Blah blah blah SMSGlobalMsgID:    123556blah' should return '123556'" do
        adapter.message_id("Blah blah blah SMSGlobalMsgID:  123556blah").should == "123556"
      end
      it "'SMSGlobalMsgID:123556' should return '123556'" do
        adapter.message_id("SMSGlobalMsgID:123556").should == "123556"
      end
    end
  end
end


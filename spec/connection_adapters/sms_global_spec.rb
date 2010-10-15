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
end


# action_sms_gateways

A collection of SMS Gateway Adapters for [action_sms](http://github.com/dwilkie/action_sms)

## Current SMS Adapters

* [SMSGlobal](http://www.smsglobal.com)
* [Tropo](http://www.tropo.com)

## Configuration

[SMSGlobal](link to wiki here)
[Tropo](link to wiki here)

## Usage

### Send an SMS and check if it was successful

    class SMS
      def recipient
        "617198378843"
      end

      def body
        "Hello world"
      end

      def from
      end
    end

    sms_gateway = ActionSms::Base.connection
    response = sms_gateway.deliver(SMS.new)
    success = sms_gateway.delivery_request_successful?(response)

### Receive an SMS

    # Assume 'params' has the data posted back to your server

    sms_gateway = ActionSms::Base.connection

    # get sender
    sender = sms_gateway.sender(params)

    # get message text
    message_text = sms_gateway.message_text(params)

    # authenticate incoming sms (see configuration for more details)
    sms_gateway.authenticate(params) # returns true or false

### Delivery receipts

    # Assume 'receipt' has the data posted back to your server as the delivery receipt

    sms_gateway = ActionSms::Base.connection

    # get status
    status = sms_gateway.status(receipt)

    # get message id
    message_id = sms_gateway.message_id(receipt)

## Creating your own SMS Gateway Adapter

Take a look at the source under `lib/action_sms_gateways/connection_adapters/sms_global.rb` and use it as a template for your own adapter.

## Installation

    gem install action_sms_gateways

### Rails

Place the following in your Gemfile:

    gem action_sms_gateways

Copyright (c) 2010 David Wilkie, released under the MIT license


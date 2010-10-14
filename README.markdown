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

### Service url

    # gets the gateway's api url
    # ActionSms::Base.connection.service_url

## Testing

When you set: `:environment => "test"` in your configuration, you get some additional test helpers.

    ActionSms::Base.establish_connection(
      :environment => "test"
    )

    sms_gateway = ActionSms::Base.connection

    # get sample incoming SMS params
    sms_gateway.sample_incoming_sms

    # get customized sample incoming SMS params
    sms_gateway.sample_incoming_sms(
      :message => "hello",
      :to => "6128392323",
      :from => "61289339432",
      :date => Time.now,
      :authentic => false          # see configuration
    )

    # get sample delivery response
    sms_gateway.sample_delivery_response

    # get sample delivery response (failed)
    sms_gateway.sample_delivery_response(:failed => true)

    # get sample message id
    sms_gateway.sample_message_id

    # get sample delivery receipt
    sms_gateway.sample_delivery_receipt

    # get customized sample delivery receipt
    sms_gateway.sample_delivery_receipt(
      :message_id => "12345",
      :status => "delivered",
      :error => "some error",
      :date => Time.now
    )

## Creating your own adapter

To create your own adapter all you need to do is open up the ActionSms::Base class
and add a class method named: `my_adapter_connection` which takes a single hash argument of configuration details and returns an instance of your adapter class. For example, lets create an adapter for clickatell:

    # clickatell.rb
    require 'action_sms/connection_adapters/abstract_adapter'

    module ActionSms
      class Base
        def self.clickatell_connection(config)
          ConnectionAdapters::ClickatellAdapter.new(config)
        end
      end
    end

    module ConnectionAdapters
      class ClickatellAdapter < AbstractAdapter
        # define your adapter here ...
        def initialize(config)
        end
      end
    end

Take a look at the [source](lib/action_sms_gateways/connection_adapters) for more details

## Installation

    gem install action_sms_gateways

### Rails

Place the following in your Gemfile:

    gem action_sms_gateways

Copyright (c) 2010 David Wilkie, released under the MIT license


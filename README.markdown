# action_sms_gateways

A collection of SMS Gateway Adapters for [action_sms](http://github.com/dwilkie/action_sms)
## Current SMS Adapters
* [SMSGlobal](http://www.smsglobal.com)
## Creating your own SMS Gateway Adapter
Take a look at the source under lib/connection_adapters/sms_global.rb and use it as a template for your own adapter. Then why not share it for all to use...

## Contributing


* Fork the project.
* Make your SMS Gateway Adapter.
* Add tests for it. This is important so I don’t break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
* Send me a pull request.

## Installation
    gem install action_sms_gateways
### Rails
Add the following to your Gemfile:

    gem action_sms_gateways


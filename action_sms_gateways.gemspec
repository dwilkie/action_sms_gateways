# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "action_sms_gateways/version"

Gem::Specification.new do |s|
  s.name        = "action_sms_gateways"
  s.version     = ActionSmsGateways::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["David Wilkie"]
  s.email       = ["dwilkie@gmail.com"]
  s.homepage    = "http://github.com/dwilkie/action_sms_gateways"
  s.summary     = %q{action_sms Gateway Adapters}
  s.description = %q{Fully implemented SMS Gateway Adapters to use with action_sms}

  s.rubyforge_project = "action_sms_gateways"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency "tropo_message"
  s.add_runtime_dependency "action_sms"
end


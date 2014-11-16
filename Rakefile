# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
# require 'bubble-wrap'
require 'bubble-wrap-http'
require 'bundler'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'HipsterNews'
  app.device_family = [:iphone, :ipad]
  app.prerendered_icon = true
  app.pods do
    pod 'SVPullToRefresh'
  end
  app.codesign_certificate = 'iOS Development: Andrew Nesbitt (66X862M9BU)'
end

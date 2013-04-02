# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
# require 'bubble-wrap'
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
end

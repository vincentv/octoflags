# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/config/boot.rb')
require 'v1'

run Rack::URLMap.new({
  "/api/v1" => Api::V1::Api
})

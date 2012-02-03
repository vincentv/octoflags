# encoding: utf-8

ENV['RACK_ENV'] = 'test'

require File.expand_path(File.dirname(__FILE__) + '/../config/boot.rb')

require 'minitest/autorun'
require 'rack/test'

SimpleCov.start do
  add_filter "/test/"
  add_group "v1" do |f| /\/lib\/v1/ =~ f.filename end
  coverage_dir "/test/coverage"
end

require 'v1'

Dir.glob(File.dirname(__FILE__) + "/factories/*.rb").each do |factory|
  require factory
end


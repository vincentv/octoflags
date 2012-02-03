# encoding: utf-8
path = File.expand_path(File.dirname(__FILE__) + '/../lib/')
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'bundler'
Bundler.setup
Bundler.require(:default, ENV['RACK_ENV'].to_sym)  # only loads environment specific gems

MongoMapper.connection = Mongo::Connection.new(ENV['MONGODB_HOSTNAME'] , ENV['MONGODB_PORT'])
MongoMapper.database = "octoflags_" + ENV['RACK_ENV']

if (ENV.include?('MONGODB_USER') and ENV.include?('MONGODB_PASSWORD'))
  MongoMapper.database.authenticate(ENV['MONGODB_USER'], ENV['MONGODB_PASSWORD'])
end


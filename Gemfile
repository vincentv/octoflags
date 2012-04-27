source "http://rubygems.org"

# web engine
gem "sinatra", "1.3.2"
# service DSL
gem "weasel_diesel", "1.0.0"
#
gem 'mongoid', "~> 2.4"
gem 'bson_ext', "~> 1.5"

gem 'rest-client'

if ENV['RACK_ENV'] != "production"
  gem "rack-test", "0.6.1"
  gem "foreman"
  gem "puma"
  gem "minitest"
  gem "guard-puma"
  gem "guard-minitest"
  gem "launchy"
  gem "rake"

  gem 'shotgun'
end

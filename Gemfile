source "http://rubygems.org"

# web engine
gem "sinatra", "1.3.2"
# service DSL
gem "weasel_diesel"
gem "wd_sinatra"
# gem 'wd_newrelic_rpm', :require => 'newrelic_rpm'

gem "mongoid", "~> 3.0.0.rc"

if RUBY_VERSION =~ /1.8/
  gem 'backports', '2.3.0'
  gem 'json'
end

if ENV['RACK_ENV'] != "production"
  gem "rack-test", "0.6.1"
  # gem "foreman"
  gem "puma"
  gem "minitest"
  gem "guard-puma"
  gem "guard-minitest"
  gem "rake"
end

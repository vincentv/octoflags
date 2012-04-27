require 'bundler'
Bundler.setup
require 'logger'
require 'json'
require 'rest-client'
ROOT = File.expand_path('..', File.dirname(__FILE__))

module Bootloader
  module_function

  def start
    unless @booted
      set_env
      load_environment
      set_loadpath
      load_lib_dependencies
      set_db_connection
      load_models unless ENV['DONT_CONNECT']
      load_apis
      load_middleware
      set_sinatra_routes
      set_sinatra_settings
      @booted = true
    end
  end

    # Boot in console mode
  def console
    unless @booted
      set_env
      load_environment
      set_loadpath
      load_lib_dependencies
      set_db_connection
      load_models unless ENV['DONT_CONNECT']
      @booted =  true
    end
  end

  def root_path
    ROOT
  end

  def set_env
    if !Object.const_defined?(:RACK_ENV)
      ENV['RACK_ENV'] ||= ENV['RAILS_ENV'] || 'development'
      Object.const_set(:RACK_ENV, ENV['RACK_ENV'])
    end
    puts "Running in #{RACK_ENV} mode" if RACK_ENV == 'development'
  end

  def load_environment(env=RACK_ENV)
    # Load the detault which can be overwritten or extended by specific
    # env config files.
    require File.join(ROOT, 'config', 'environments', 'default.rb')
    env_file = File.join(ROOT, "config", "environments", "#{env}.rb")
    if File.exist?(env_file)
      require env_file
    else
      debug_msg = "Environment file: #{env_file} couldn't be found, using only the default environment config instead." unless env == 'development'
    end
    # making sure we have a LOGGER constant defined.
    unless Object.const_defined?(:LOGGER)
      Object.const_set(:LOGGER, Logger.new($stdout))
    end
    LOGGER.debug(debug_msg) if debug_msg
    require File.join(ROOT, 'config', 'app_config')
  end

  def set_loadpath
    $: << ROOT
    $: << File.join(ROOT, 'lib')
    $: << File.join(ROOT, 'models')
  end

  def load_lib_dependencies
    # WeaselDiesel is the web service DSL gem used to define services.
    require 'weasel_diesel'
    require 'sinatra'
    require 'auth_helpers'
    require 'weasel_sinatra_ext'
    require 'mongoid'
    require 'base64'
    require 'digest/md5'
  end

  def set_db_connection
    # Set the AR logger
    if Object.const_defined?(:LOGGER)
      Mongoid.logger = LOGGER
    else
      Mongoid.logger = Logger.new($stdout)
    end
    # Establish the DB connection
    db_file = File.join(ROOT, "config", "mongoid.yml")
    if File.exist?(db_file)
      Mongoid.load!(db_file)
    else
      raise "#{db_file} file missing, can't connect to the DB"
    end
  end

  def load_models
    Dir.glob(File.join(ROOT, "models", "**", "*.rb")).each do |model|
      require model
    end
  end

  # DSL routes are located in the api folder
  def load_apis
    Dir.glob(File.join(ROOT, "api", "**", "*.rb")).each do |api|
      require api
    end
  end

  def set_sinatra_routes
    WSList.all.sort.each{|api| api.load_sinatra_route }
    WSList.all.sort.each{|api| p api.load_sinatra_route }
  end

  def load_middleware
    require File.join(ROOT, 'config', 'middleware')
  end

  def set_sinatra_settings
    # Using the :production env would wrap errors instead of displaying them
    # like in dev mode
    set :environment, RACK_ENV
    set :root, ROOT
    set :app_file, __FILE__
    set :public_folder, File.join(ROOT, "public")
    # Checks on static files before dispatching calls
    enable :static
    # enable rack session
    enable :session
    set :raise_errors, false
    # enable that option to run by calling this file automatically (without using the config.ru file)
    # enable :run
    use Rack::ContentLength
  end

end

# called after the environment is setup and the basic dependencies are loaded
# but before the models are loaded.
#
# Here you want to load your dependencies and maybe set your
# datastore.


############### AIRBRAKE ###############
airbrake_config_file = File.join(WDSinatra::AppLoader.root_path, 'config', 'airbrake.yml')
if File.exist?(airbrake_config_file)
    airbrake_config = YAML.load_file(airbrake_config_file)[RACK_ENV]
    if airbrake_config && airbrake_config['enabled']
        require 'airbrake'
        Airbrake.configure do |config|
            config.api_key = airbrake_config['api_key']
            (airbrake_config['params_filters'] - config.params_filters).each do |param|
                config.params_filters << param
            end
            config.environment_name = RACK_ENV
            config.host = airbrake_config['host'] if airbrake_config['host']
            config.logger = LOGGER
        end
    end
end

############### DATASTORE ###############
db_config_file = File.join(WDSinatra::AppLoader.root_path, "config", "mongoid.yml")
if File.exist?(db_config_file)
    require 'mongoid'
    Mongoid.load!(db_config_file)
    Mongoid.logger = LOGGER
else
    raise "#{db_config_file} file missing, can't connect to the DB"
end

Dir.glob(File.join(WDSinatra::AppLoader.root_path, "lib", 'presenters', "*.rb")).each do |file|
    require file
end


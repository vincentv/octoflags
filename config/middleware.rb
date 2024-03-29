if defined?(NewRelic)
  if RACK_ENV == 'development'
    require 'new_relic/rack/developer_mode'
    use NewRelic::Rack::DeveloperMode
  end
  if NewRelic::Control.instance.agent_enabled?
    LOGGER.info "New Relic monitoring enabled App name: '#{NewRelic::Control.instance['app_name']}', Mode: '#{NewRelic::Control.instance.app}'"
  end
end

# Use this middleware with AR to avoid threading issues.
# require 'active_record'
# use ActiveRecord::ConnectionAdapters::ConnectionManagement

use Airbrake::Rack if defined?(Airbrake)
use Rack::ContentLength

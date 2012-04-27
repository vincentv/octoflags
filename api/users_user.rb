describe_service "users/:username" do |service|
  service.formats   :json
  service.http_verb :get
  service.disable_auth # on by default

  # INPUT
  service.param.string  :username, :required => true

  # OUTPUT
  service.response do |response|
    response.object do |obj|
      obj.string :username, :doc => "The name of the person to greet."
    end
  end

  # DOCUMENTATION
  service.documentation do |doc|
    doc.overall "This service provides a simple hello world implementation example."
    doc.param :username, "The name of the person to greet."
    doc.example "<code>curl -I 'http://localhost:9292/hello_world?name=Matt'</code>"
  end

  # ACTION/IMPLEMENTATION
  service.implementation do
    u = User.first(conditions: {login: params[:username]})

    {
      :login => u.login,
      :location => u.location,
      :flags => [
        {"id" => 1,
          "admin" => true,
          "name" => "Heidi",
          "state" => "retired",
          "last_login_at" => "2011-09-22T22:46:35-07:00"
      },
        {"id" => 2,
          "admin" => false,
          "name" => "Giana",
          "state" => "playing",
          "last_login_at" => "2011-09-22T22:46:35-07:00"
      }]
    }.to_json
  end

end

describe_service "users/:username/flagged" do |service|
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
    {:message => "Hello #{params[:name]}", :at => Time.now}.to_json
  end

end

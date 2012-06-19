describe_service "users/:username" do |service|
  service.formats   :json
  service.http_verb :post
  service.disable_auth # on by default

  # INPUT
  service.param.string  :username, :required => true

  # OUTPUT
  service.response do |response|
    response.element do |obj|
      obj.attribute :login     => :string, :doc => "The name of the person to greet."
      obj.attribute :location  => :string, :doc => "The location of the person."

      obj.array :flags do |flag|
          flag.attribute :name        => :string, :doc => "The name of the person to greet."
          flag.attribute :description => :string, :doc => "The name of the person to greet."
          flag.attribute :owner       => :string, :doc => "The name of the person to greet."
          flag.attribute :language    => :string, :doc => "The name of the person to greet."
      end
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

    if u
     begin
        raw = RestClient.post("https://api.github.com/authorizations", :accept => :json)
        rep =  Repository.create!( JSON.parse( raw ) )
      rescue RestClient::ResourceNotFound => e
        halt 404, "Github user not found "
      end
    end

    return UserPresenter.new( u ).to_json
  end

end

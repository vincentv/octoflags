describe_service "users/:username/flagged/:owner/:project" do |service|
  service.formats   :json
  service.http_verb :delete
  service.disable_auth # on by default

  # INPUT
  service.param.string  :username, :required => true
  service.param.string  :owner, :required => true
  service.param.string  :project, :required => true

  # OUTPUT
  service.response do |response|
    response.object do |obj|
      obj.string :username, :doc => "The name of the person to greet."
      obj.string :owner, :doc => "The name of the person to greet."
      obj.string :project, :doc => "The name of the person to greet."
    end
  end

  # DOCUMENTATION
  service.documentation do |doc|
    doc.overall "This service provides a simple hello world implementation example."
    doc.param :name, "The name of the user."
    doc.param :owner, "The name of the project owner."
    doc.param :project, "The name of the project."
    doc.example "<code>curl -I 'http://localhost:9292/hello_world?name=Matt'</code>"
  end

  # ACTION/IMPLEMENTATION
  service.implementation do
    {:message => "Hello #{params[:name]}", :at => Time.now}.to_json
    unless user = User.first(conditions: {login: params[:username]})
      halt 404, "User not found"
    end

    rep = Repository.first(:conditions => {
      :name => params[:project],
      "owner.login" => params[:owner]
    })

    unless rep
        halt 404, "Repository not found "
    end

    user.unflag rep
  end

end

describe_service "users/:username" do |service|
  service.formats   :json
  service.http_verb :get
  service.disable_auth # on by default

  # INPUT
  service.param.string  :username, :required => true

  # OUTPUT
  service.response do |response|
    response.element do |obj|
      obj.attribute :login     => :string, :doc => "The nickname of the person."
      obj.attribute :location  => :string, :doc => "The location of the person."

      obj.array :flags do |flag|
          flag.attribute :name        => :string, :doc => "The name of the project."
          flag.attribute :description => :string, :doc => "The description of the project."
          flag.attribute :owner       => :string, :doc => "The owner's nickname of the project."
          flag.attribute :language    => :string, :doc => "The language used in the project."
      end
    end
  end

  # DOCUMENTATION
  service.documentation do |doc|
    doc.overall "This service provides a simple hello world implementation example."
    doc.overall "This service provides some information of the person and projects flagged by him."
    doc.param :username, "The name of the person to find."
    doc.example "<code>curl -I 'http://localhost:9292/users/vincentv'</code>"
  end

  # ACTION/IMPLEMENTATION
  service.implementation do
    u = User.where(:login => params[:username]).first

    halt 404, "User not found" unless u

    return UserPresenter.new( u ).to_json
  end

end

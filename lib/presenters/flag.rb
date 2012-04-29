class FlagPresenter

  attr_reader :name, :description, :owner, :language

  def initialize(flag)
    @name        = flag.name
    @description = flag.description
    @owner       = flag.owner.login
    @language    = flag.language

  end

end

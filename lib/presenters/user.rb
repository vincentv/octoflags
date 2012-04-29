class UserPresenter

  attr_reader :login, :location, :flags

  def initialize(user)
    @login    = user.login
    @location = user.location

    @flags = user.repositories.map {|repo|
      FlagPresenter.new( repo )
    }

  end

end


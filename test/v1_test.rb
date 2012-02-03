require_relative 'helper'

include Rack::Test::Methods


describe Api::V1::Api do

  def app()  Api::V1::Api end

  before do
    Api::V1::Models::User.delete_all
    Api::V1::Models::Repository.delete_all

  end

  it "can't get unkown user" do
    get '/users/unkown_user'
    last_response.status.must_equal 404
    last_response.body.must_equal 'User not found'
  end

  it "can't create unkown user" do
    post '/users', {'user' => 'unkown_user'}

    last_response.status.must_equal 404
    last_response.body.must_equal 'User not found'
  end


  it "can't list flagged repos for unkown user" do
    get '/users/unkown_user/flagged'
    last_response.status.must_equal 404
    last_response.body.must_equal 'User not found'
  end

  it "can't flag repo for unkown user" do
    put '/user/unkown_user/flagged/octocat/Hello-World'
    last_response.status.must_equal 404
    last_response.body.must_equal 'User not found'
  end

  it "can't unflag repo for unkown user" do
    delete '/user/unkown_user/flagged/octocat/Hello-World'

    last_response.status.must_equal 404
    last_response.body.must_equal 'User not found'
  end

  describe "with octocat user" do
    before do
      @user = Factory.create(:basic_user)
    end

    it "get a single user" do
      get "/users/#{@user.login}"
      last_response.status.must_equal 200

      data = JSON::parse last_response.body
      data['login'].must_equal @user.login
    end

    it "create defunkt user" do
      post '/users', {'user' => 'defunkt'}
      last_response.status.must_equal 201

      u = Api::V1::Models::User.first(:login => 'defunkt')
      u.wont_equal false
      u.login.must_equal 'defunkt'
    end

    it "has 0 flagged project"  do
      get "/users/#{@user.login}/flagged"
      last_response.status.must_equal 200

      data = JSON::parse last_response.body
      data.length.must_equal 0
    end


    it "flags rails/rails project from github"  do
      put "/user/#{@user.login}/flagged/rails/rails"
      last_response.status.must_equal 204

      u = Api::V1::Models::User.first(:login => @user.login)
      u.repositories.length.must_equal 1
    end

    it "can't flag unkown project" do
      put "/user/#{@user.login}/flagged/azerty/azerty"
      last_response.status.must_equal 404
      last_response.body.must_equal 'Repository not found'
    end

    it "can't unflag unkown project" do
      delete "/user/#{@user.login}/flagged/azerty/azerty"
      last_response.status.must_equal 404
      last_response.body.must_equal 'Repository not found'
    end

    describe "with repository flagged" do
      before do
        @repo = Factory.create(:basic_repo)
        @user.flag(@repo.id)
        @repo.flag
      end

      it "has 1 flagged project"  do
        get "/users/#{@user.login}/flagged"
        last_response.status.must_equal 200

        data = JSON::parse last_response.body
        data.length.must_equal 1

        data[0]['owner'].must_equal @user.login
      end

      it "can unflag repository"  do
        delete "/user/#{@user.login}/flagged/#{@repo.owner}/#{@repo.name}"
        last_response.status.must_equal 204

        u = Api::V1::Models::User.first(:login => @user.login)
        u.repositories.length.must_equal 0
      end
    end
  end
end


module Api

  class RepositoryNotFound < StandardError; end
  class UserNotFound < StandardError; end

  module V1

    require 'rest_client'
    require 'v1/models/user.rb'
    require 'v1/models/repository.rb'

    class Api < Sinatra::Base

      get '/users/:user' do
        begin
          u = db_user(params[:user])
          u.to_json
        rescue UserNotFound
          halt 404, "User not found"
        end
      end

      # param :user
      post '/users' do
        begin
          status 201

          u = gh_user(params[:user])
          Models::User.create(u)

        rescue UserNotFound
          halt 404, "User not found"
        end
      end

      get '/users/:user/flagged' do
        begin
          u = db_user(params[:user])
          u.flags.to_json
        rescue UserNotFound
          halt 404, "User not found"
        end
      end

      put '/user/:user/flagged/:owner/:name' do
        begin
          status 204

          u = db_user(params[:user])
          project = repository params[:owner], params[:name]

          u.flag(project.id)
          project.flag

        rescue UserNotFound
          halt 404, "User not found"
        rescue RepositoryNotFound
          halt 404, "Repository not found"
        end

      end

      delete '/user/:user/flagged/:owner/:name' do
        begin
          status 204

          u = db_user(params[:user])
          project = db_repository(params[:owner], params[:name])

          u.unflag(project.id)
          project.unflag


        rescue UserNotFound
          halt 404, "User not found"
        rescue RepositoryNotFound
          halt 404, "Repository not found"
        end
      end


      helpers do
        def repository owner, name
          begin
            @repository ||= db_repository(owner, name)

          rescue RepositoryNotFound
            data = gh_repository(owner, name)
            @repository = Models::Repository.create(data)
          end
        end

        def db_repository owner, name
          unless repo = Models::Repository.first(:owner => owner, :name => name)
            raise RepositoryNotFound
          end
          repo
        end

        def gh_repository owner, name
          raw = RestClient.get("https://api.github.com/repos/#{owner}/#{name}", :accept => :json)
          data = JSON.parse(raw)

        rescue RestClient::ResourceNotFound => e
          raise RepositoryNotFound
        end


        def db_user user
          unless user = Models::User.first(:login => user)
            raise UserNotFound
          end
          user
        end

        def gh_user user
          raw = RestClient.get("https://api.github.com/users/#{user}", :accept => :json)
          data = JSON.parse(raw)

        rescue RestClient::ResourceNotFound => e
          raise UserNotFound
        end

      end

    end
  end
end

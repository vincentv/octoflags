module Api
  module V1
    module Models

      require 'set'

      class User
        include MongoMapper::Document

        set_collection_name :users

        key :login, String, :unique => true, :required => true

        key :email, String, :required => true

        timestamps!

        key :repositories, Set,  :typecast => 'ObjectId'
        many :flags, :in => :repositories, :class_name => 'Api::V1::Models::Repository'

        def flag(rid)
          repositories << rid
          save
        end

        def unflag(rid)
          repositories.delete(rid)
          save
        end
      end
      User.ensure_index(:login)
    end
  end
end

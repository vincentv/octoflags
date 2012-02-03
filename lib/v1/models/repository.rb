module Api
  module V1
    module Models
      class Repository
        include MongoMapper::Document

        set_collection_name :repositories

        key :url, String, :unique => true, :required => true

        key :name, String, :required => true
        key :owner, String, :required => true
        key :description, String
        key :language, String

        key :marked, Integer, :default => 0

        key :pushed_at, Time

        timestamps!

        validates_uniqueness_of :name, :scope => :owner

        def flag
          @marked = @marked.next
          save
        end

        def unflag
          @marked = @marked.pred
          save
        end
      end

      Repository.ensure_index([[:owner, 1], [:name, 1]])
      Repository.ensure_index(:url)

    end
  end
end

require 'set'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :login, type: String
  field :email, type: String
  field :location, type: String

  field :repository_ids, type: Set
  has_and_belongs_to_many :repositories, :autosave => true,  inverse_of: nil

  validates_presence_of :login
  validates_uniqueness_of :login

  index :login

  def flag ( repository )
    repositories << repository unless repositories.include? repository
  end

  def unflag( repository )
    repositories.delete( repository )
  end
end


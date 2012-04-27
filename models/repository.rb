class Repository
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :name, type: String
  field :description, type: String
  field :language, type: String
  field :flagged, type: Integer, default: 0
  field :pushed_at, type: DateTime

  validates_presence_of :owner, :name
  validates_uniqueness_of :name, :scope => :owner

  embeds_one :owner

  index(
    [
      [ :owner, Mongo::ASCENDING ],
      [ :name, Mongo::ASCENDING ]
  ],
    unique: true
  )

  def flag
    @marked = @marked.next
    save
  end

  def unflag
    @marked = @marked.pred
    save
  end
end

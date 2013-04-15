class Location
  include Mongoid::Document
  include Gmaps4rails::ActsAsGmappable
  acts_as_gmappable

  belongs_to :category

  field :latitude,        type: Float
  field :longitude,       type: Float
  field :gmaps,           type: Boolean

  field :address,         type: String
  field :name,            type: String
  field :content,         type: String
  field :is_approved,     type: Boolean, default: false

  def gmaps4rails_address
    "#{address}"
  end

  def as_json(options)
    super :include => :category, :except => [ :category_id, :is_approved ]
  end

end

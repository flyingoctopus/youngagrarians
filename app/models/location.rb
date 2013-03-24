class Location
  include Mongoid::Document
  include Gmaps4rails::ActsAsGmappable
  acts_as_gmappable

  field :latitude,        type: Float
  field :longitude,       type: Float
  field :gmaps,           type: Boolean

  field :address,         type: String
  field :name,            type: String
  field :content,         type: String
  field :type,            type: String
  field :is_approved,     type: Boolean

  def gmaps4rails_address
    "#{address}"
  end

end

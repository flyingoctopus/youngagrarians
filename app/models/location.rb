class Location
  include Mongoid::Document
  acts_as_gmappable :position => :address

  field :name, type: String
  field :content, type: String
  field :address, type: Array
  field :type, type: String
end

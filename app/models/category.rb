class Category
  include Mongoid::Document
  has_many :locations

  field :name, type: String
end

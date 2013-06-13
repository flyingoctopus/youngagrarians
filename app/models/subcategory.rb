class Subcategory < ActiveRecord::Base
  attr_accessible :name
  belongs_to :category
  has_and_belongs_to_many :locations
end

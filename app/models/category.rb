class Category < ActiveRecord::Base
  has_many :locations
  has_many :subcategory
  attr_accessible :name

  def as_json(options)
    super :include => :subcategory
  end
end

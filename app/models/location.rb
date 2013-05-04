class Location < ActiveRecord::Base
  include Gmaps4rails::ActsAsGmappable
  acts_as_gmappable

  belongs_to :category

  attr_accessible :latitude, :longitutde, :gmaps, :address, :name, :content, :bioregion, :phone, :url, :fb_url, :twitter_url, :description, :subcategory, :is_approved

  def gmaps4rails_address
    "#{address}"
  end

  def as_json(options)
    super :include => :category, :except => [ :category_id, :is_approved ]
  end

  def self.search(term)
    result = []
    if not term.nil? and not term.empty?
      interested_fields = ["address", "name", "content","bioregion"]
      interested_fields.each do |i|
        result = result + Location.where( i.to_sym => /^#{term}/i )
      end
    end
    return result.uniq
  end
end

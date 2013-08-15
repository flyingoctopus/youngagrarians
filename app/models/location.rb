class Location < ActiveRecord::Base
  include Gmaps4rails::ActsAsGmappable
  acts_as_gmappable :process_geocoding => :process

  belongs_to :category
  has_and_belongs_to_many :subcategory

  attr_accessible :latitude, :longitude, :gmaps, :address, :name, :content, :bioregion, :phone, :url, :fb_url, :twitter_url, :description, :is_approved, :category_id, :resource_type, :email, :postal, :show_until

  def gmaps4rails_address
    "#{address}"
  end

  def process
    if address.nil? || address.empty?
      return false
    end
    true
  end

  def as_json(options = nil)
    super :include => [ :category, :subcategory ], :except => [ :category_id, :is_approved ]
  end

  def self.search(term, province = nil)
    result = []
    if not term.nil? and not term.empty?

      category = Category.find_by_name term
      subcategory = Category.find_by_name term

      if not category.nil?
        result = result + Location.find( :all, :conditions => ["category_id = ?", category.id] )
      end

      if not subcategory.nil?
        result = result + Location.all( :include => :subcategory, :conditions => ["subcategories.id = ?", subcategory.id ])
      end

      interested_fields = ["address", "name", "postal", "content","bioregion","phone","url","fb_url","twitter_url","description"]

      provinces = {
        "Alberta" => "AB",
        "British Columbia" => "BC",
        "Manitoba" => "MB",
        "New Brunswick" => "NB",
        "Newfoundland" => "NL",
        "Nova Scotia" => "NS",
        "Ontario" => "ON",
        "Prince Edward Island" => "PE",
        "Quebec" => "QC",
        "Saskatchewan" => "SK",
        "Northwest Territories" => "NT",
        "Nunavut" => "NU",
        "Yukon" => "YT"
      }

      interested_fields.each do |i|
        #result = result + Location.where( i.to_sym => /^#{term}/i )
        if province.nil?
          result = result + Location.find( :all, :conditions => ["is_approved = 1 AND #{i} LIKE ? AND show_until < ?", "%#{term}%", Date.today])
        else
          abbrev = provinces[province]
          result = result + Location.find( :all, :conditions => ["is_approved = 1 AND #{i} LIKE ? AND ( address LIKE ? OR address LIKE ? ) AND show_until > ?", "%#{term}%", "%#{abbrev}%", "%#{province}%", Date.today])
        end



      end
    end
    return result.uniq
  end
end

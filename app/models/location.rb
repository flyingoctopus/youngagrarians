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
  field :bioregion,       type: String
  field :phone,           type: String
  field :url,             type: String
  field :fb_url,          type: String
  field :twitter_url,     type: String
  field :description,     type: String
  field :subcategory,     type: String

  field :is_approved,     type: Boolean, default: false

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
      puts "searching: #{term}"
      interested_fields.each do |i|
        result = result + Location.where( i.to_sym => /^#{term}/i )
      end
      puts "got #{result.length}"
    end
    return result.uniq
  end
end

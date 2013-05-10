class CreateLocation < ActiveRecord::Migration
  def change
    create_table :locations do |l|
      l.float :latitude
      l.float :longitude
      l.boolean :gmaps
      l.string :address
      l.string :name
      l.text :content
      l.string :bioregion
      l.string :phone
      l.string :url
      l.string :fb_url
      l.string :twitter_url
      l.text :description
      l.string :subcategory
      l.boolean :is_approved

      l.timestamps
    end
  end
end

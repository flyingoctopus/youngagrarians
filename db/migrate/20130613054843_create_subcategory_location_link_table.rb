class CreateSubcategoryLocationLinkTable < ActiveRecord::Migration

  def change
    create_table :locations_subcategories, :id => false do |t|
      t.integer :location_id
      t.integer :subcategory_id
    end
  end

end

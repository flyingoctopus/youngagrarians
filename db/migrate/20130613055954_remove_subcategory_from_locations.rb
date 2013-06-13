class RemoveSubcategoryFromLocations < ActiveRecord::Migration
  def up
    remove_column :locations, :subcategory_id
  end

  def down
    add_column :locations, :subcategory_id, :integer
  end
end

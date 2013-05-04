class AddCategoryToLocations < ActiveRecord::Migration
  def change
    change_table :locations do |l|
      l.index :is_approved
      l.integer :categories_id
    end
  end
end

class ChangeSubcategoryToLink < ActiveRecord::Migration

  def change
    remove_column :locations, :subcategory
    add_column :locations, :subcategory_id, :integer
  end

end

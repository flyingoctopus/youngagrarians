class RenameCategoriesLinkField < ActiveRecord::Migration
  def change
    rename_column :locations, :categories_id, :category_id
  end
end

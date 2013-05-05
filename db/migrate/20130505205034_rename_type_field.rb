class RenameTypeField < ActiveRecord::Migration
  def change
    rename_column :locations, :type, :resource_type
  end
end

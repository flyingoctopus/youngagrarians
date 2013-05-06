class AddDefaultValueToLocationsIsApproved < ActiveRecord::Migration
  def change
    change_column :locations, :is_approved, :boolean, :default => 0
  end
end

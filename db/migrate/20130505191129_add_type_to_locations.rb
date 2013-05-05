class AddTypeToLocations < ActiveRecord::Migration
  def change
    change_table :locations do |l|
      l.string :type
    end
  end
end

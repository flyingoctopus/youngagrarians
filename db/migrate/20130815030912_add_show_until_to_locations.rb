class AddShowUntilToLocations < ActiveRecord::Migration
  def change
    change_table :locations do |l|
      l.date :show_until
      l.index :show_until
    end
  end
end

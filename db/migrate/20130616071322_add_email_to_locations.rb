class AddEmailToLocations < ActiveRecord::Migration
  def change
    change_table :locations do |l|
      l.string :email
    end
  end
end

class AddPostalCodeToLocation < ActiveRecord::Migration
  def change
    change_table :locations do |l|
      l.string :postal
    end
  end
end

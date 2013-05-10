class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string :first_name
      u.string :last_name
      u.string :username
      u.string :email
      u.string :password_salt
      u.string :encrypted_password
      u.string :password_reset_key
      u.timestamps
    end
  end
end

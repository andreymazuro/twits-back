class AddUserEmail < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :password, :hashed_password
    add_column :users, :email, :string
  end
end

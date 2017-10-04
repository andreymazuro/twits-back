class ChangeColumnsName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :fullName, :fullname
    rename_column :users, :avatarUrl, :avatarurl
  end
end

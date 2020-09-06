class RenameProfileColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :profile, :favorite_anime
  end
end

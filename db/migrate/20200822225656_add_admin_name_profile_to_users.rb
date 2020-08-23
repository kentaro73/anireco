class AddAdminNameProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :name, :string, null: false 
    add_column :users, :profile, :string 
  end
end

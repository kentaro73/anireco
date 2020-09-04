class ChangeDataPostIdUserIdToLikes < ActiveRecord::Migration[6.0]
  def change
    change_column :likes, :post_id, :integer
    change_column :likes, :user_id, :integer
  end
end

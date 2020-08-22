class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :staff
      t.string :favorite_scene
      t.string :broadcast
      t.string :cast
      t.integer :episode

      t.timestamps
    end
  end
end

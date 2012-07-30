class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.text :body
    end
    add_index :posts, :user_id
  end
end

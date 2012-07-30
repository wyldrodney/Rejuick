class CreateReceivers < ActiveRecord::Migration
  def change
    create_table :receivers do |t|
      t.references :post
      t.references :user
    end
    add_index :receivers, :post_id
    add_index :receivers, :user_id
  end
end

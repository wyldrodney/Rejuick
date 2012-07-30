class CreateTagmaps < ActiveRecord::Migration
  def change
    create_table :tagmaps do |t|
      t.references :post
      t.references :tag
    end
    add_index :tagmaps, :post_id
    add_index :tagmaps, :tag_id
  end
end

class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :writer
      t.integer :reader
      t.boolean :confirm, default: true
    end
    add_index :subscriptions, [:writer, :confirm]
    add_index :subscriptions, [:reader, :confirm]
  end
end

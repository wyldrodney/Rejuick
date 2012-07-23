class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :jid
      t.string :nick
      t.string :lang
      t.boolean :confirm_subs, default: true
      t.text :about
    end
    add_index :users, :jid
    add_index :users, :nick
  end
end

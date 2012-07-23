# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120723142228) do

  create_table "subscriptions", :force => true do |t|
    t.integer "writer"
    t.integer "reader"
    t.boolean "confirm", :default => true
  end

  add_index "subscriptions", ["reader", "confirm"], :name => "index_subscriptions_on_reader_and_confirm"
  add_index "subscriptions", ["writer", "confirm"], :name => "index_subscriptions_on_writer_and_confirm"

  create_table "users", :force => true do |t|
    t.string  "jid"
    t.string  "nick"
    t.string  "lang"
    t.boolean "confirm_subs", :default => true
    t.text    "about"
  end

  add_index "users", ["jid"], :name => "index_users_on_jid"
  add_index "users", ["nick"], :name => "index_users_on_nick"

end

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

ActiveRecord::Schema.define(:version => 20120731160640) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "posts", :force => true do |t|
    t.integer "user_id"
    t.text    "body"
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "receivers", :force => true do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  add_index "receivers", ["post_id"], :name => "index_receivers_on_post_id"
  add_index "receivers", ["user_id"], :name => "index_receivers_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer "writer"
    t.integer "reader"
    t.boolean "confirm", :default => true
  end

  add_index "subscriptions", ["reader", "confirm"], :name => "index_subscriptions_on_reader_and_confirm"
  add_index "subscriptions", ["writer", "confirm"], :name => "index_subscriptions_on_writer_and_confirm"

  create_table "tagmaps", :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "tagmaps", ["post_id"], :name => "index_tagmaps_on_post_id"
  add_index "tagmaps", ["tag_id"], :name => "index_tagmaps_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

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

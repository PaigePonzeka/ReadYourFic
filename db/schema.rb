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

ActiveRecord::Schema.define(:version => 20120501122749) do

  create_table "authors", :force => true do |t|
    t.integer  "ff_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "characters", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ff_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "protagnists", :force => true do |t|
    t.integer  "story_id"
    t.integer  "character_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "relationships", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "ship_id"
    t.integer  "character_id"
  end

  create_table "ships", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stories", :force => true do |t|
    t.string   "title"
    t.integer  "ff_id"
    t.integer  "author_id"
    t.text     "summary"
    t.string   "rating"
    t.string   "language"
    t.text     "theme"
    t.integer  "chapters"
    t.integer  "words"
    t.integer  "reviews",    :default => 0
    t.boolean  "complete"
    t.date     "published"
    t.date     "updated"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "storyrelations", :force => true do |t|
    t.integer  "story_id"
    t.integer  "ship_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

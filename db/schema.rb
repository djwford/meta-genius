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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160126172644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clips", force: :cascade do |t|
    t.string   "href"
    t.string   "title"
    t.integer  "module_metafile_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "course_metafiles", force: :cascade do |t|
    t.string   "title"
    t.text     "short_description"
    t.text     "description"
    t.string   "author"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "module_count"
    t.text     "topics_list"
    t.string   "course_id"
    t.text     "audience_tags"
    t.text     "topics_tags"
    t.text     "tools_tags"
    t.text     "certification_tags"
    t.string   "software_required"
    t.string   "category"
  end

  create_table "course_modules", force: :cascade do |t|
    t.string   "author"
    t.string   "name"
    t.integer  "course_metafile_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "module_metafiles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "author"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "course_title"
    t.integer  "module_number"
    t.string   "course_id"
  end

  create_table "tags", force: :cascade do |t|
    t.text     "audience_tags"
    t.text     "topics_tags"
    t.text     "tools_tags"
    t.text     "certification_tags"
    t.string   "courseId"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "topics_list"
  end

end

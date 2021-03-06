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

ActiveRecord::Schema.define(version: 20160320223056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "checklist_items", force: :cascade do |t|
    t.integer  "checklist_id"
    t.string   "description"
    t.boolean  "checked",      default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "checklist_items", ["checklist_id"], name: "index_checklist_items_on_checklist_id", using: :btree

  create_table "checklists", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "checklists", ["slug", "user_id"], name: "index_checklists_on_slug_and_user_id", unique: true, using: :btree
  add_index "checklists", ["user_id"], name: "index_checklists_on_user_id", using: :btree

  create_table "linkset_links", force: :cascade do |t|
    t.integer  "linkset_id"
    t.string   "name"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "linkset_links", ["linkset_id"], name: "index_linkset_links_on_linkset_id", using: :btree

  create_table "linksets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "linksets", ["slug", "user_id"], name: "index_linksets_on_slug_and_user_id", unique: true, using: :btree
  add_index "linksets", ["user_id"], name: "index_linksets_on_user_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  add_index "notes", ["slug", "user_id"], name: "index_notes_on_slug_and_user_id", unique: true, using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "shares", force: :cascade do |t|
    t.string   "destination_path"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "token"
  end

  add_index "shares", ["destination_path"], name: "index_shares_on_destination_path", unique: true, using: :btree
  add_index "shares", ["token"], name: "index_shares_on_token", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.citext   "username"
    t.citext   "email"
    t.string   "password_digest"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "activation_digest"
    t.datetime "activated_at"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "checklist_items", "checklists"
  add_foreign_key "checklists", "users"
  add_foreign_key "linkset_links", "linksets"
  add_foreign_key "linksets", "users"
  add_foreign_key "notes", "users"
end

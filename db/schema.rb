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

ActiveRecord::Schema.define(version: 20150506011451) do

  create_table "checklist_pictures", force: true do |t|
    t.string   "picture"
    t.integer  "checklist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklist_pictures", ["checklist_id"], name: "index_checklist_pictures_on_checklist_id"

  create_table "checklists", force: true do |t|
    t.text     "description"
    t.integer  "order"
    t.string   "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "baketime"
    t.integer  "baketemp"
    t.integer  "steptype"
  end

  add_index "checklists", ["recipe_id"], name: "index_checklists_on_recipe_id"

  create_table "comments", force: true do |t|
    t.string   "text"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["recipe_id"], name: "index_comments_on_recipe_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "database_ingredients", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followed_id"], name: "index_follows_on_followed_id"
  add_index "follows", ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
  add_index "follows", ["follower_id"], name: "index_follows_on_follower_id"

  create_table "ingredients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.integer  "vote"
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["recipe_id"], name: "index_ratings_on_recipe_id"
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id"

  create_table "recipe_ingredients", force: true do |t|
    t.float    "quantity"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recipe_id"
    t.integer  "measurement_id"
    t.integer  "ingredient_id"
  end

  add_index "recipe_ingredients", ["ingredient_id"], name: "index_recipe_ingredients_on_usda_ingredient_id"
  add_index "recipe_ingredients", ["measurement_id"], name: "index_recipe_ingredients_on_measurement_id"
  add_index "recipe_ingredients", ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.float    "rating"
    t.string   "picture"
  end

  add_index "recipes", ["name", "user_id"], name: "index_recipes_on_name_and_user_id", unique: true
  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id"

  create_table "usda_ingredients", force: true do |t|
    t.string   "ndb"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.string   "fname"
    t.string   "lname"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.string   "string"
    t.string   "reset_digest"
    t.boolean  "activated"
    t.boolean  "admin"
    t.datetime "reset_sent_at"
  end

end

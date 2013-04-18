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

ActiveRecord::Schema.define(:version => 20130418073204) do

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "restaurants", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.string   "google_photo"
    t.integer  "google_price"
    t.float    "google_rating"
    t.float    "lat"
    t.float    "lng"
    t.string   "google_id",                                                        :null => false
    t.string   "google_reference"
    t.text     "keywords"
    t.text     "google_types",      :default => "restaurant, establishment, food"
    t.string   "formatted_address"
    t.string   "street_number"
    t.string   "street"
    t.string   "city"
    t.string   "admin_area"
    t.string   "zip"
    t.string   "country"
    t.string   "phone"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.boolean  "delta",             :default => true,                              :null => false
  end

  add_index "restaurants", ["delta"], :name => "index_restaurants_on_delta"
  add_index "restaurants", ["google_id"], :name => "index_restaurants_on_google_id"
  add_index "restaurants", ["google_rating"], :name => "index_restaurants_on_google_rating"

  create_table "reviews", :force => true do |t|
    t.integer  "restaurant_id", :null => false
    t.integer  "user_id",       :null => false
    t.integer  "rating"
    t.text     "text"
    t.string   "keywords"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "reviews", ["restaurant_id"], :name => "index_reviews_on_restaurant_id"
  add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "first_name"
    t.date     "birthday",                  :null => false
    t.string   "gender"
    t.string   "e_mail"
    t.integer  "fb_id",        :limit => 8, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "fb_pic"
    t.string   "fb_pic_large"
    t.decimal  "price"
    t.float    "lat"
    t.float    "long"
    t.string   "ip_address"
  end

  add_index "users", ["fb_id"], :name => "index_users_on_fb_id"

end

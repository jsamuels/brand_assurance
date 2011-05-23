# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100113184145) do

  create_table "color_bars", :force => true do |t|
    t.integer  "patch_num"
    t.string   "name"
    t.integer  "r",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "g",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "b",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "c",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "m",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "y",          :limit => 10, :precision => 10, :scale => 0
    t.integer  "k",          :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", :force => true do |t|
    t.integer  "member_id"
    t.string   "location"
    t.string   "name"
    t.string   "make"
    t.string   "model"
    t.integer  "roll_width"
    t.string   "serial_number"
    t.string   "kind"
    t.integer  "active",        :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["serial_number"], :name => "xserial_number", :unique => true

  create_table "member_preferences", :force => true do |t|
    t.integer  "member_id"
    t.string   "pref"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pageviews", :force => true do |t|
    t.integer  "user_id"
    t.string   "dist_num",    :limit => 20
    t.string   "request_url", :limit => 200
    t.string   "pagename",    :limit => 80
    t.string   "session",     :limit => 250
    t.string   "ip_address",  :limit => 16
    t.string   "referer",     :limit => 200
    t.string   "user_agent",  :limit => 200
    t.string   "browser",     :limit => 60
    t.string   "os",          :limit => 40
    t.datetime "created_at"
  end

  create_table "patches", :force => true do |t|
    t.integer  "proof_id"
    t.integer  "is_spot",     :limit => 1
    t.string   "patch_name"
    t.string   "patch"
    t.float    "spectral_1"
    t.float    "spectral_2"
    t.float    "spectral_3"
    t.float    "spectral_4"
    t.float    "spectral_5"
    t.float    "spectral_6"
    t.float    "spectral_7"
    t.float    "spectral_8"
    t.float    "spectral_9"
    t.float    "spectral_10"
    t.float    "spectral_11"
    t.float    "spectral_12"
    t.float    "spectral_13"
    t.float    "spectral_14"
    t.float    "spectral_15"
    t.float    "spectral_16"
    t.float    "spectral_17"
    t.float    "spectral_18"
    t.float    "spectral_19"
    t.float    "spectral_20"
    t.float    "spectral_21"
    t.float    "spectral_22"
    t.float    "spectral_23"
    t.float    "spectral_24"
    t.float    "spectral_25"
    t.float    "spectral_26"
    t.float    "spectral_27"
    t.float    "spectral_28"
    t.float    "spectral_29"
    t.float    "spectral_30"
    t.float    "spectral_31"
    t.float    "spectral_32"
    t.float    "spectral_33"
    t.float    "spectral_34"
    t.float    "spectral_35"
    t.float    "spectral_36"
    t.float    "l"
    t.float    "a"
    t.float    "b"
    t.float    "c"
    t.float    "h"
    t.float    "t_l"
    t.float    "t_a"
    t.float    "t_b"
    t.float    "t_c"
    t.float    "t_h"
    t.float    "dE2000"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proofs", :force => true do |t|
    t.integer   "device_id"
    t.string    "operator"
    t.string    "customer"
    t.string    "jobnum"
    t.string    "profile_name"
    t.string    "profile_mod_date"
    t.integer   "sticker_count"
    t.integer   "spot_color_count"
    t.integer   "proofsize"
    t.integer   "subproofs"
    t.string    "i1_serialnum"
    t.timestamp "proofdate",        :null => false
    t.float     "dEab"
    t.float     "dEcmc"
    t.float     "dE94"
    t.float     "dE2000"
    t.integer   "pass"
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_preferences", :force => true do |t|
    t.integer  "user_id"
    t.string   "pref"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "member_id"
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "jobs", :force => true do |t|
    t.integer  "brand_color_id"
    t.string   "name"
    t.string   "substrate"
    t.string   "product_type"
    t.string   "printing_type"
    t.string   "job_number"
    t.string   "sku"
    t.integer  "lot_id"
  end

end

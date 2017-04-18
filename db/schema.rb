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

ActiveRecord::Schema.define(version: 20170412050808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "alerts", force: :cascade do |t|
    t.integer "user_id"
    t.string  "google_place_id"
    t.string  "warning"
    t.string  "city_country"
    t.string  "readable_address"
    t.index ["user_id"], name: "index_alerts_on_user_id", using: :btree
  end

  create_table "comedian_alerts", force: :cascade do |t|
    t.integer  "comedian_id"
    t.integer  "alert_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["alert_id"], name: "index_comedian_alerts_on_alert_id", using: :btree
    t.index ["comedian_id"], name: "index_comedian_alerts_on_comedian_id", using: :btree
  end

  create_table "comedians", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "mugshot_file_name"
    t.string   "mugshot_content_type"
    t.integer  "mugshot_file_size"
    t.datetime "mugshot_updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "gigs", force: :cascade do |t|
    t.datetime "time"
    t.integer  "venue_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "venue_booking_url"
    t.string   "ticketmaster_booking_url"
    t.index ["time"], name: "index_gigs_on_time", using: :btree
    t.index ["venue_id"], name: "index_gigs_on_venue_id", using: :btree
  end

  create_table "spots", force: :cascade do |t|
    t.integer  "gig_id"
    t.integer  "comedian_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["comedian_id"], name: "index_spots_on_comedian_id", using: :btree
    t.index ["gig_id", "comedian_id"], name: "index_spots_on_gig_id_and_comedian_id", using: :btree
    t.index ["gig_id"], name: "index_spots_on_gig_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "venues", force: :cascade do |t|
    t.string    "name"
    t.string    "description"
    t.datetime  "created_at",                                                                null: false
    t.datetime  "updated_at",                                                                null: false
    t.string    "readable_address"
    t.string    "google_place_id"
    t.string    "phone"
    t.string    "deets"
    t.geography "location",         limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.index ["location"], name: "index_venues_on_location", using: :gist
  end

end

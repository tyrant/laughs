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

ActiveRecord::Schema.define(version: 20170227192024) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

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

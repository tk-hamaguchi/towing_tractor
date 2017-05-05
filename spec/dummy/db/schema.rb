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

ActiveRecord::Schema.define(version: 20170505035852) do

  create_table "towing_tractor_docker_containers", force: :cascade do |t|
    t.integer "image_id"
    t.text "env"
    t.text "cmd"
    t.datetime "last_keepalived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "towing_tractor_docker_images", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "towing_tractor_docker_servers", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "keepalived_at"
    t.text "ca_cert"
    t.text "client_cert"
    t.text "client_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

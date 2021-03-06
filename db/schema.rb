# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_11_104259) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contents", force: :cascade do |t|
    t.integer "occurences"
    t.bigint "word_id"
    t.bigint "page_id"
    t.index ["page_id"], name: "index_contents_on_page_id"
    t.index ["word_id"], name: "index_contents_on_word_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "url"
    t.string "signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
  end

  create_table "subheadings", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "page_id"
    t.index ["page_id"], name: "index_subheadings_on_page_id"
    t.index ["word_id"], name: "index_subheadings_on_word_id"
  end

  create_table "titles", force: :cascade do |t|
    t.bigint "word_id"
    t.bigint "page_id"
    t.index ["page_id"], name: "index_titles_on_page_id"
    t.index ["word_id"], name: "index_titles_on_word_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "str"
  end

end

class CreateSubheadings < ActiveRecord::Migration[7.0]
  def change
    create_table :subheadings do |t|
      t.references :word
      t.references :page
    end
  end
end

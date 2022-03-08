class CreateContents < ActiveRecord::Migration[7.0]
  def change
    create_table :contents do |t|
      t.integer :count
      t.references :word
      t.references :page
    end
  end
end

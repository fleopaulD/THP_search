class AddTitleToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :title, :string
  end
end

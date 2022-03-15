class RenameCountFromContents < ActiveRecord::Migration[7.0]
  def change
    rename_column(:contents, :count, :occurences)
  end
end

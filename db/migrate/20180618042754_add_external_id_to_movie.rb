class AddExternalIdToMovie < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :external_id, :integer
  end
end

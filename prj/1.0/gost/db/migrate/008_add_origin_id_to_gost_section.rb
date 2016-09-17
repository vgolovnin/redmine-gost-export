class AddOriginIdToGostSection < ActiveRecord::Migration
  def change
    add_column :gost_sections, :origin_id, :integer
  end
end

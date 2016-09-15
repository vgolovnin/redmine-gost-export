class AddIndexToGostSection < ActiveRecord::Migration
  def change
    add_column :gost_sections, :index, :integer
  end
end

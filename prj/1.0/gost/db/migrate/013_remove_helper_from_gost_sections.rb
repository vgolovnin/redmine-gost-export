class RemoveHelperFromGostSections < ActiveRecord::Migration
  def change
    remove_column :gost_sections, :helper
  end
end
class AddLocationToGostInfo < ActiveRecord::Migration
  def change
    add_column :gost_info, :location, :string
  end
end

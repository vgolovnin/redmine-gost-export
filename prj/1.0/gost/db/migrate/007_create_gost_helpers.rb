class CreateGostHelpers < ActiveRecord::Migration
  def change
    create_table :gost_helpers do |t|
      t.string :name
      t.text :settings
      t.references :section
    end
  end
end

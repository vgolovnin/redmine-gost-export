class CreateGostSections < ActiveRecord::Migration
  def change
    create_table :gost_sections do |t|
      t.string :title
      t.text :description
      t.text :text
      t.text :tips
      t.string :helper
      t.references :parent, polymorphic: true, index: true
    end
  end
end
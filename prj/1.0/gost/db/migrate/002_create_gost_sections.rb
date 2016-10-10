class CreateGostSections < ActiveRecord::Migration
  def change
    create_table :gost_sections do |t|
      t.integer :index
      t.string :title
      t.text :description
      t.text :text
      t.text :tips
      t.boolean :is_appendix
      t.references :parent, polymorphic: true, index: true
      t.integer :origin_id
    end
  end
end
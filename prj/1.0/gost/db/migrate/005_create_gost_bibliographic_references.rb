class CreateGostBibliographicReferences < ActiveRecord::Migration
  def change
    create_table :gost_bibliographic_references do |t|
      t.text :text
      t.references :project, index: true, foreign_key: true
    end
  end
end

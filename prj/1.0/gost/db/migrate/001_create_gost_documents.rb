class CreateGostDocuments < ActiveRecord::Migration
  def change
    create_table :gost_documents do |t|
      t.string :title
      t.boolean :has_annotation, default: false
      t.boolean :has_changeslist, default: false
      t.string :document_code
      t.string :document_gost
      t.text :description
      t.boolean :has_bibliography, default: true
      t.boolean :has_toc
      t.references :project, index: true, foreign_key: true
    end
  end
end

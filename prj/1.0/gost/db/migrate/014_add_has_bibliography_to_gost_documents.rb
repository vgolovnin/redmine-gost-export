class AddHasBibliographyToGostDocuments < ActiveRecord::Migration
  def change
    add_column :gost_documents, :has_bibliography, :boolean, default: true
  end
end

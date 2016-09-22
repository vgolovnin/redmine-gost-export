class AddHasTocToGostDocuments < ActiveRecord::Migration
  def change
    add_column :gost_documents, :has_toc, :boolean
  end
end

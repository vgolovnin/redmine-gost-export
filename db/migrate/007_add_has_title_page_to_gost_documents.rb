class AddHasTitlePageToGostDocuments < ActiveRecord::Migration
  def change
    add_column :gost_documents, :has_approvepage, :boolean, default: true
    add_column :gost_documents, :has_titlepage, :boolean, default: true
  end
end

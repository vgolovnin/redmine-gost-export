class AddVersionToGostDocuments < ActiveRecord::Migration
  def change
    add_column :gost_documents, :version, :string, default: '01'
  end
end

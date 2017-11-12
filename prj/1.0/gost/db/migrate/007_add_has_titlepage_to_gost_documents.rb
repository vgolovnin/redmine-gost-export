class AddHasApprovePageToGostDocuments  < ActiveRecord::Migration
  def change
    add_column :gost_documents, :has_approvepage, :boolean, default: true
  end
end

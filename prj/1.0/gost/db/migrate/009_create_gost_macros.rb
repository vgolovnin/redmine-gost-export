class CreateGostMacros < ActiveRecord::Migration
  def change
    create_table :gost_macros do |t|
      t.string :title
      t.text :text
      t.belongs_to :project
    end
  end
end

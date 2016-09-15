class CreateGostInfo < ActiveRecord::Migration
  def change
    create_table :gost_info do |t|
      t.string :title
      t.string :organization
      t.string :organization_unit
      t.integer :project_type
      t.string :special_mark
      t.text :description
      t.string :country_code
      t.string :organization_code
      t.string :okp_code
      t.references :project, index: true, foreign_key: true
    end
  end
end

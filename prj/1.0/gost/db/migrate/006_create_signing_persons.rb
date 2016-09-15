class CreateSigningPersons < ActiveRecord::Migration
  def change
    create_table :signing_persons do |t|
      t.integer :role
      t.string :name
      t.string :position
      t.references :gost_info, index: true, foreign_key: true
    end
  end
end

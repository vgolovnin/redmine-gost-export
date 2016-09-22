class AddIsAppendixToGostSections < ActiveRecord::Migration
  def change
    add_column :gost_sections, :is_appendix, :boolean
  end
end
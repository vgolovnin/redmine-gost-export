class GostInfo < ActiveRecord::Base
  self.table_name = 'gost_info'
  belongs_to :project
  has_many :signers

  accepts_nested_attributes_for :signers

  enum project_type: [:component, :complex]
end
class GostInfo < ActiveRecord::Base
  self.table_name = 'gost_info'
  belongs_to :project
  has_many :signers

  accepts_nested_attributes_for :signers
  validates :title, :organization, :organization_unit,
            :organization_code, :country_code, :okp_code, presence: true
end
class Signer < ActiveRecord::Base

belongs_to :gost_info

validates :name, :position, :role, presence: true


def self.all_set_for_project(project)
  signers = project.gost_info.signers
  signers.agreed and signers.approved and signers.performer
end

#fixme enum
def self.agreed
  self.where(role: 1).first
end

def self.approved
  self.where(role: 2).first
end

def self.performer
  self.where(role: 3).first
end

self.table_name = 'signing_persons'
end
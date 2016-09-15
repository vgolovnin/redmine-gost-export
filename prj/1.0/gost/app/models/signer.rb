class Signer < ActiveRecord::Base

belongs_to :gost_info

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
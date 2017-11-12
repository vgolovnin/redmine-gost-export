class GostMacro < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :text
  belongs_to :project
end
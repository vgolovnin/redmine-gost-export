class GostHelper < ActiveRecord::Base
  belongs_to :section
  serialize :settings
end
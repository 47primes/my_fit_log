class Exercise < ActiveRecord::Base
  attr_accessible :name, :instructions
  
  belongs_to :user
  
  validates_presence_of :name
end

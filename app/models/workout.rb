class Workout < ActiveRecord::Base
  attr_accessible :completed_at, :summary
  
  belongs_to :user
  has_many :routines, dependent: :destroy

  validates_presence_of :completed_at
  
  def self.per_page
    25
  end
end

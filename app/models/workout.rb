class Workout < ActiveRecord::Base
  attr_accessible :completed_at, :summary
  
  belongs_to :user
  has_many :routines, dependent: :destroy

  validates_presence_of :completed_at
  
  scope :by_month, ->(user ,month=Time.now.month, year=Time.now.year) { where("user_id = ? and extract(month from workouts.completed_at) = ? and extract(year from workouts.completed_at) = ?", user.id, month, year) }

  def self.per_page
    25
  end
end

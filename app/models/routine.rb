class Routine < ActiveRecord::Base
  attr_accessible :exercise_id, :reps, :sets, :workout_id
  
  belongs_to :exercise
  belongs_to :workout
  
  delegate :name, :instructions, to: :exercise
end

class Routine < ActiveRecord::Base
  attr_accessible :distance, :duration, :exercise_id, :notes, :reps, :sets, :workout_id
  
  belongs_to :exercise
  belongs_to :workout
  
  delegate :name, :instructions, to: :exercise
end

json.workouts @workouts do |json, workout|
  json.partial! "workout", workout: workout
end

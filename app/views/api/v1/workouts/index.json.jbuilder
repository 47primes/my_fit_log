json.array! @workouts do |json, workout|
  json.partial! "api/v2/workouts/workout", workout: workout
end

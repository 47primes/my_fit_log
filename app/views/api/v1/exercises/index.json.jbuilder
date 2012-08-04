json.exercises @exercises do |json, exercise|
  json.partial! "api/v2/exercises/exercise", exercise: exercise
end

json.exercises @exercises do |json, exercise|
  json.partial! "exercise", exercise: exercise
end

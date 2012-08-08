json.id workout.id
json.completed_at workout.completed_at.to_i
json.summary workout.summary

json.routines do |json|
  json.partial! "api/v2/routines/routine", routines: workout.routines
end

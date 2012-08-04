json.completed_at workout.completed_at.to_i
json.summary workout.summary

json.routines workout.routines do |json, routine|
  json.partial! "api/v2/routines/routine", routine: routine
end

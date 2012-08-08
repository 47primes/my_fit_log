json.array!(routines) do |json, routine|
  json.(routine, :id, :name, :distance, :duration, :reps, :sets, :notes)
end

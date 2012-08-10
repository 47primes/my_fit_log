json.array!(routines) do |json, routine|
  json.(routine, :id, :name, :reps, :sets)
end

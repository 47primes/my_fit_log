# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

ActiveRecord::Base.transaction do
  user = User.find_or_create_by_name "Mike Bradford", email: "mbradford@47primes.com", password: "test"

  exercise_names = ["Bench Press", "Squats", "Dead Lifts", "Power Cleans", "Biceps Curls", "Triceps Curls", "Leg Extensions", "Chin Ups"]

  exercise_names.each do |name|
    user.exercises.create! name: name
  end

  [-12, -7, -6, -4, -2, 0, 2, 5, 7, 12, 16, 19, 22, 26, 31].each do |i|
    workout = user.workouts.create! completed_at: i.days.from_now
    5.times do |i|
      exercise = user.exercises.find_by_name exercise_names[rand(exercise_names.size)]
      workout.routines.create! exercise_id: exercise.id, reps: rand(20), sets: rand(10)
    end
  end
end


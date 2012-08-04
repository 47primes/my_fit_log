FactoryGirl.define do

  factory :routine do
    workout { create(:workout) }
    exercise { FactoryGirl.factories.create_random_exercise(user: workout.user) }
    distance { rand(50) }
    duration { rand(100) }
    reps { rand(20) }
    sets { rand(10) }
    notes { Forgery(:basic).text }
  end
  
end

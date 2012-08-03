FactoryGirl.define do

  factory :routine do
    workout { create(:workout) }
    exercise { FactoryGirl.factories.create_random_exercise(user: workout.user) }
  end
  
end

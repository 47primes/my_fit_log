FactoryGirl.define do
  
  factory :user do
    name { Forgery(:name).full_name }
    email { Forgery(:email).address }
    password { Forgery(:basic).password }
    password_confirmation { password }
    
    factory :user_with_workouts do
      ignore do
        workout_count 5
      end
      
      after(:create) do |user, evaluator| 
        create_list(:workout, evaluator.workout_count, :user => user)
      end
    end
    
    factory :user_with_routines do
      ignore do
        workout_count 5
        routine_count 5
      end
      
      after(:create) do |user, evaluator| 
        create_list(create(:workout_with_routines, evaluator.routine_count), evaluator.workout_count, user: user)
      end
    end
  end
  
end

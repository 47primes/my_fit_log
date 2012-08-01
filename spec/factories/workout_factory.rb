FactoryGirl.define do

  factory :workout do
    user { create(:user) }
    summary { Forgery(:basic).text }
    completed_at { Time.now - rand(1000000) }
    
    factory :workout_with_routines do
      ignore do
        routine_count 5
      end
      
      after(:create) do |workout, evaluator|
        create_list(:routine, evaluator.routine_count, workout: workout)
      end
    end
  end
  
end

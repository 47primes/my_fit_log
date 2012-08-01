FactoryGirl.define do
  
  factory :exercise do
    user { create(:user) }
    name "Push ups"
    instructions { Forgery(:basic).text }
    
    factory :bench_press do
      name "Bench press"
    end
        
    factory :squats do
      name "Squats"
    end
    
    factory :pull_ups do
      name "Pull ups"
    end
    
    factory :dead_lift do
      name "Dead lift"
    end
    
    factory :walking do
      name "Walking"
    end
    
    factory :running do
      name "Running"
    end
    
    factory :body_pump do
      name "Body pump"
    end
    
    factory :kickboxing do
      name "Kickboxing"
    end
    
    factory :cycling do
      name "Cycling"
    end
    
    factory :swimming do
      name "Swimming"
    end
    
  end
  
end

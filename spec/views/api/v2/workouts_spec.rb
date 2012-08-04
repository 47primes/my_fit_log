require 'spec_helper'

describe "api/v2/workouts/index" do
  it "should render" do
    workouts = create_list(:workout, 5)

    assign(:workouts, workouts)
    render

    view.should render_template(partial: "_workout", count: workouts.size)  
  end
end


describe "api/v2/workouts/show" do
  it "should render" do
    workout = create(:workout)

    assign(:workout, workout)
    render

    view.should render_template(partial: "_workout")
  end
end

describe "api/v2/workouts/workout" do
  it "should render" do
    workout = create(:workout_with_routines)

    render partial: subject, locals: {workout: workout}
    json = JSON.parse(rendered)
    
    json["completed_at"].should == workout.completed_at.to_i
    json["summary"].should == workout.summary
    view.should render_template(partial: "_routine", count: workout.routines.count)
  end
end


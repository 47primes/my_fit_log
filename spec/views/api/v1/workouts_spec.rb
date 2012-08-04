require 'spec_helper'

describe "api/v1/workouts/index" do
  it "should render" do
    workouts = create_list(:workout, 5)

    assign(:workouts, workouts)
    render
    
    view.should render_template(partial: "api/v2/workouts/_workout", count: workouts.size)
  end
end


describe "api/v1/workouts/show" do
  it "should render" do
    workout = create(:workout)

    assign(:workout, workout)
    render

    view.should render_template(partial: "api/v2/workouts/_workout")
  end
end

describe "api/v1/workouts/workout" do
  it "should render" do
    workout = create(:workout_with_routines)

    render partial: subject, locals: {workout: workout}
    
    view.should render_template(partial: "api/v2/workouts/_workout")
  end
end

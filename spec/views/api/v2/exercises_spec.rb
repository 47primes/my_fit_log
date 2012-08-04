require 'spec_helper'

describe "api/v2/exercises/index" do
  it "should render" do
    exercises = create_list(:exercise, 5)

    assign(:exercises, exercises)
    render

    view.should render_template(partial: "_exercise", count: exercises.size)  
  end
end

describe "api/v2/exercises/show" do
  it "should render" do
    exercise = create(:running)

    assign(:exercise, exercise)
    render

    view.should render_template(partial: "_exercise")
  end
end

describe "api/v2/exercises/exercise" do
  it "should render" do
    exercise = create(:running)

    render partial: subject, locals: {exercise: exercise}
    json = JSON.parse(rendered)

    json["name"].should == exercise.name
    json["instructions"].should == exercise.instructions
  end
end

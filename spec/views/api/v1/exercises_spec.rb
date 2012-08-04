require 'spec_helper'

describe "api/v1/exercises/index" do
  it "should render" do
    exercises = create_list(:exercise, 5)

    assign(:exercises, exercises)
    render

    view.should render_template(partial: "api/v2/exercises/_exercise", count: exercises.size)  
  end
end

describe "api/v1/exercises/show" do
  it "should render" do
    exercise = create(:running)

    assign(:exercise, exercise)
    render

    view.should render_template(partial: "api/v2/exercises/_exercise")
  end
end

describe "api/v1/exercises/exercise" do
  it "should render" do
    exercise = create(:running)

    render partial: subject, locals: {exercise: exercise}
  
    view.should render_template(partial: "api/v2/exercises/_exercise")
  end
end

require 'spec_helper'

describe "api/v1/routines/routine" do
  it "should render" do
    routine = create(:routine)
    render partial: subject, locals: {routines: [routine]}

    view.should render_template(partial: "api/v2/routines/_routine")
  end
end

require 'spec_helper'

describe "api/v2/routines/routine" do
  it "should render" do
    routine = create(:routine)
    render partial: subject, locals: {routine: routine}
    json = JSON.parse(rendered)

    %w(name reps sets duration distance notes).each do |attr|
      json[attr].should == routine.send(attr)
    end
  end
end

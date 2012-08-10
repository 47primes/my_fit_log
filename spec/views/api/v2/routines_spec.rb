require 'spec_helper'

describe "api/v2/routines/routine" do
  it "should render" do
    routine = create(:routine)
    render partial: subject, locals: {routines: [routine]}
    json = JSON.parse(rendered)

    json.each do |j|
      %w(name reps sets).each do |attr|
        j[attr].should == routine.send(attr)
      end
    end
  end
end

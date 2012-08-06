require 'spec_helper'

describe "api/v1/sessions/create" do
  it "should render" do
    user = create(:user)

    assign(:user, user)
    render

    json = JSON.parse(rendered)

    json["api_key"].should == user.api_key
  end
end

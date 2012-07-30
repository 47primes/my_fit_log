require 'spec_helper'

describe UserMailer do
  before do
    @user = User.create!(:email => "email@test.com", :password => "test", :password_confirmation => "test")
  end
  
  describe ".create_confirmation" do
    it "should send an account creation confirmation email" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        email = UserMailer.create_confirmation(@user).deliver
        email.to.should == [@user.email]
        email.subject.should == "[MyFitLog] Your Account Has Been Created"
      end
    end
  end
  
  describe ".update_confirmation" do
    it "should send an account update confirmation email" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        email = UserMailer.update_confirmation(@user).deliver
        email.to.should == [@user.email]
        email.subject.should == "[MyFitLog] Your Account Has Been Updated"
      end
    end
  end
  
  describe ".password_reset_confirmation" do
    it "should send a password reset confirmation email" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        email = UserMailer.password_reset_confirmation(@user).deliver
        email.to.should == [@user.email]
        email.subject.should == "[MyFitLog] Your Password Has Been Reset"
      end
    end
  end
end

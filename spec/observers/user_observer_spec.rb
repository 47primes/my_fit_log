require 'spec_helper'

describe UserObserver do
  before do
    @user = User.new(:email => "email@test.com", :password => "test", :password_confirmation => "test")
  end
  
  describe "#after_create" do
    it "should send a create_confirmation email" do
      UserMailer.should_receive(:create_confirmation).with(@user).and_return(double("mail", deliver: nil))
      UserObserver.instance.after_create(@user)
    end
    
    it "deliver one email" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        UserObserver.instance.after_create(@user)
      end
    end
  end
  
  describe "#after_update" do
    it "should send an update_confirmation email" do
      UserMailer.should_receive(:update_confirmation).with(@user).and_return(double("mail", deliver: nil))
      UserObserver.instance.after_update(@user)
    end
    
    it "deliver one email" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        UserObserver.instance.after_update(@user)
      end
    end
  end
  
  describe "#password_reset" do
    it "should send a password_reset_confirmation email" do
      UserMailer.should_receive(:password_reset_confirmation).with(@user).and_return(double("mail", deliver: nil))
      UserObserver.instance.password_reset(@user)
    end
    
    it "deliver one email" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        UserObserver.instance.password_reset(@user)
      end
    end
  end
end

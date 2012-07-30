require "spec_helper"

describe User do  
  describe "#email" do
    it "should fail if invalid" do
      user = User.new(:email => "@test.com")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false

      user = User.new(:email => "adftest.com")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false

      user = User.new(:email => "adfad@testcom")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false

      user = User.new(:email => "asdf@test")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false

      user = User.new(:email => "invalid@email.c0m")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false

      user = User.new(:email => "invalid@email.n|t")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false

      user = User.new(:email => "invalid@email.g-v")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false

      user = User.new(:email => "invalid@email.toooolong")
      user.valid?.should be_false
      user.errors[:email].empty?.should be_false
    end
  end

  describe "#api_key" do
    it "should be present before validation" do
      user = User.new(:email => "email@test.com", :password => "test", :password_confirmation => "test")
      
      user.valid?.should be_true
      user.api_key.should match(User::API_KEY_PATTERN)
    end
  end
  
  describe "#reset_password" do
    before do
      @user = User.create!(:email => "email@test.com", :password => "test", :password_confirmation => "test")
      @old_password_digest = @user.password_digest
      @old_api_key = @user.api_key
    end
    
    it "should change password" do
      @user.reset_password
      @user.password_digest.should_not == @old_password_digest
    end
    
    it "should change api_key" do
      @user.reset_password
      @user.api_key.should_not == @old_api_key
    end
    
    it "should notify observers" do
      @user.should_receive(:notify_observers).with(:password_reset)
      @user.reset_password
    end
  end
  
  describe ".generate_password" do
    it "should generate a random password of min length" do
      password = User.generate_password(32)

      password.length.should == 32
    end

    it "should include special chars if asked to" do
      password = User.generate_password(8, true)
      
      password.should match(User::API_KEY_PATTERN)
    end

    it "should not include special chars if asked not to" do
      password = User.generate_password(8)
      
      password.match(User::API_KEY_PATTERN).should == nil
    end

    it "should default to a length of 8 if min length is not set" do
      password = User.generate_password
      
      password.length.should == 8
    end
  end
    
  describe ".generate_api_key" do
    it "should generate a random, unique 40-character API key containing mixed case alphanumeric and one of a set of special characters" do
      user = User.create!(:email => "test@test.com", :password => "test", :password_confirmation => "test")
      
      user.api_key.should match(User::API_KEY_PATTERN)
    end
  end

end

class UserMailer < ActionMailer::Base
  default from: "MyFitLog Support <fitlog@47primes.com>"
  
  def create_confirmation(user)
    @user = user
    mail(subject: "[MyFitLog] Your Account Has Been Created", to: @user.email)
  end
  
  def update_confirmation(user)
    @user = user
    mail(subject: "[MyFitLog] Your Account Has Been Updated", to: @user.email)
  end
  
  def password_reset_confirmation(user)
    @user = user
    mail(subject: "[MyFitLog] Your Password Has Been Reset", to: @user.email)
  end
  
end

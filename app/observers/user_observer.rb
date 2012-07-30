class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.create_confirmation(user).deliver
  end
  
  def after_update(user)
    UserMailer.update_confirmation(user).deliver
  end
  
  def password_reset(user)
    UserMailer.password_reset_confirmation(user).deliver
  end
end

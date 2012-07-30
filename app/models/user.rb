class User < ActiveRecord::Base
  API_KEY_PATTERN  = /^(?=.*[\$\*\-_])[\w\$\*\-_]+$/i
  EMAIL_PATTERN     = /^([a-z0-9]+[-\._]?)+[a-z0-9]+@([a-z0-9]+[-\._]?)+[a-z0-9]+\.[a-z]{2,8}$/ui
  
  attr_accessible :email, :name, :password, :password_confirmation
  
  has_many :exercises
  has_many :workouts, dependent: :destroy
  
  before_validation :set_api_key, on: :create
  
  has_secure_password
  
  validates_presence_of     :email
  validates_uniqueness_of   :email, message: "is already in use"
  validates_format_of       :email, with: EMAIL_PATTERN
  validates_format_of			  :api_key, with: API_KEY_PATTERN
  validates_length_of       :api_key, is: 40
  
  class <<self    
    def generate_password(length=8, include_special=false)
		  chars = ("a".."z").to_a + ("0".."9").to_a
		  chars += %w($ * - _) if include_special
		  
      password = Array.new(length).map { chars[rand(chars.length)].send([:upcase, :downcase][rand(2)]) }.join
      if include_special
        while !API_KEY_PATTERN.match(password) do
          password = generate_password(length, include_special)
        end
      end
      password
	  end
    
    def generate_api_key
      api_key = generate_password(40, true)
      while exists?(api_key: api_key) do
        api_key = generate_password(40, true)
      end
      api_key
    end
  end

  def reset_password
    password = password_confirmation = User.generate_password
    self.api_key = User.generate_api_key
    save!
    notify_observers :password_reset
  end

  private
  
  def set_api_key
    self.api_key = self.class.generate_api_key
  end
end

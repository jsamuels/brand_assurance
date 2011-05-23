require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :member
  has_many :user_preferences
  has_many :pageviews


  validates_presence_of	:name
	validates_uniqueness_of	:name

	attr_accessor	:password_confirmation
	validates_confirmation_of:password

	def validate
		errors.add_to_base("Missing Password") if hashed_password.blank?
	end

	def self.authenticate(name, password)
		user = self.find_by_name(name)
		if user
			expected_password = encrypted_password(password, user.salt)
			if user.hashed_password != expected_password
				user = nil
			end
			user
  		end
	end

	def after_destroy
	  if User.count.zero?
	  	raise "Can't delete last user"
	  end	
	end

	# passowrd is a virtual attribute
	def password
		@password
	end

	def password=(pwd)
		@password = pwd
		return if pwd.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end	
		
	
	private
	def self.encrypted_password(password, salt)
		string_to_hash = password + "turkey" + salt # 'turkey makes it harder to guess
		Digest::SHA1.hexdigest(string_to_hash)
	end

	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
	end
end


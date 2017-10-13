class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable

	validates_uniqueness_of :auth_token

  has_many :messages, :foreign_key => 'author_id'

	before_create :generate_authentication_token!

  def conversations # Pseudo has_many
    Conversation.involving(self)
  end

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: self.auth_token)
  end
end

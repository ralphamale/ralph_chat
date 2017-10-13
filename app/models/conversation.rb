class Conversation < ActiveRecord::Base
	has_many :messages

	belongs_to :user1, :class_name => 'User'
	belongs_to :user2, :class_name => 'User'

	before_validation do
		if user1_id && user2_id # Otherwise, validation will catch 
			self.user1_id, self.user2_id = [self.user1_id, self.user2_id].sort
		end
	end

	#better error message than "can't be blank"
	validates_presence_of :user1, :user2, :message => 'must exist' 
	validates_uniqueness_of :user2_id, scope: :user1_id, :message => 'conversation already exists between users'
	# Purposely allowing you to have a conversation with yourself, like on iMessage

	scope :involving, -> (user) do
		where("conversations.user1_id =? OR conversations.user2_id =?", user.id, user.id)		
	end

	scope :between, -> (user1, user2) do
		user1_id, user2_id = [user1.id, user2.id].sort
		where("conversations.user1_id = ? AND conversations.user2_id = ?", user1_id, user2_id)
	end
end

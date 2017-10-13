class Message < ActiveRecord::Base
	validates_presence_of :content
	validates_presence_of :conversation, :author, :message => 'Must exist'

  belongs_to :conversation
  belongs_to :author, :class_name => 'User', foreign_key: 'author_id'
end

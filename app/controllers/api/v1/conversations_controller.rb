class Api::V1::ConversationsController < ApplicationController
	before_action :authenticate_with_token!
	respond_to :json

	def index
		respond_with Conversation.involving(current_user)
	end

	def create
		user2 = User.find(conversation_params[:user2_id])
		existing_conversation = Conversation.between(current_user, user2).first

		if existing_conversation
			render json: existing_conversation, status: 200
		else
			conversation = Conversation.new(conversation_params.merge(:user1_id => current_user.id))

			if conversation.save
				render json: conversation, status: 201
			else
				render json: { errors: conversation.errors }, status: 422
			end
		end
	end

	private

		def conversation_params
			params.require(:conversation).permit(:user2_id)
		end
end

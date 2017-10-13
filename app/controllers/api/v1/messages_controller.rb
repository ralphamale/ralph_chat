class Api::V1::MessagesController < ApplicationController
	before_action :authenticate_with_token!, :validate_conversation!
	respond_to :json

	def index
		respond_with conversation.messages
	end

	def create
		message = conversation.messages.build(message_params.merge(author_id: current_user.id))
		if message.save
			render json: message, status: 201
		else
			render json: { errors: message.errors }, status: 422
		end
	end

	private
	
		def validate_conversation!
			unless [conversation.user1_id, conversation.user2_id].include?(current_user.id)
				render json: { errors: "You must be a part of this conversation" }, status: :unauthorized
			end
		end

		def conversation
			@conversation ||= Conversation.find(params[:conversation_id])
		end

		def message_params
			params.require(:message).permit(:content)
		end
end

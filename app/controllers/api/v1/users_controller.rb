class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:index]
  respond_to :json

  def index
    respond_with User.all
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, :v1, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end

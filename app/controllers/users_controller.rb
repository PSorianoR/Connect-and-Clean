include ReviewsHelper

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  before_action :set_mode_params, only: [:mode]


  def show
    # You can customize this action to display the user's information and other related data.
    @cleaner_reviews = cleaner_all_reviews(@user)
    @manager_reviews = manager_all_reviews(@user)
  end

  def mode
    data = JSON.parse(request.body.read)
    session[:user_role] = data["role"]

    respond_to do |format|
      format.json { render json: { success: true, role: session[:user_role] } }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_mode_params
    @mode_params = params.permit(:role, :user)
  end
end

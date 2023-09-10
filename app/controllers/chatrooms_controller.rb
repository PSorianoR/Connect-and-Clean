class ChatroomsController < ApplicationController
  before_action :set_chatroom, only: %i[show]

  def index
  end

  def show
    @message = Message.new
    @job_id = params[:job_id]
  end

  def create
    user = current_user
    receiver_user = User.find(params[:user][:user_id])

    @chatroom = Chatroom.all.find do |chatroom|
      chatroom.chatroom_members.exists?(user: user) &&
      chatroom.chatroom_members.exists?(user: receiver_user) &&
      if session[:user_role] == "manager"
        chatroom.chatroom_members.find_by(user: receiver_user).profession == "cleaner"
      else
        chatroom.chatroom_members.find_by(user: receiver_user).profession == "manager"
      end
    end

    unless @chatroom
      @chatroom = Chatroom.create!
      if session[:user_role] == "manager"
        ChatroomMember.create!(chatroom: @chatroom, user: user, profession: "manager")
        ChatroomMember.create!(chatroom: @chatroom, user: receiver_user, profession: "cleaner")
      else
        ChatroomMember.create!(chatroom: @chatroom, user: user, profession: "cleaner")
        ChatroomMember.create!(chatroom: @chatroom, user: receiver_user, profession: "manager")
      end
    end

    if job_id = params[:user][:job_id]
      redirect_to chatroom_path(@chatroom, job_id: job_id)
    else
      redirect_to chatroom_path(@chatroom)
    end
  end

  private

  def set_chatroom
    unless Chatroom.all.empty?
      @chatroom = Chatroom.find(params[:id])
    end
  end
end

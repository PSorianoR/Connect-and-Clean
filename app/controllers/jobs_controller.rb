class JobsController < ApplicationController
  def index

    user = current_user
    if session[:user_role] == "manager"
      profession = "management"
      get_job(profession)
      # managementTeams = user.teams.where(profession: "management")
      # @jobs = []
      # managementTeams.each do |managementTeam|
      #   @jobs += managementTeam.property.jobs
      # end
    elsif session[:user_role] == "cleaner"
      profession = "cleaning"
      get_job(profession)
      filter_application_status
    end
  end

  def show
  end

  def new
  end

  def create
  end

  def destroy
  end

  def get_job(selected_profession)
    user = current_user
    teams = user.teams.where(profession: selected_profession)
      @jobs = []
    teams.each do |team|
      @jobs += team.property.jobs
    end
  end

  def filter_application_status
    @jobs = @jobs.reject do |job|
      job.job_applications.where(user_id: current_user.id, status: "rejected").exists? ||
      job.job_applications.where(status: ["accepted", "completed"]).where.not(user_id: current_user.id).exists?
    end
  end
end

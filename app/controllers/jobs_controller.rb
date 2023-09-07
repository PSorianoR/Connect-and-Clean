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
    @jobs = Job.find(params[:id])
  end

  def new
    @jobs = Job.new
  end

  def create
      @job = Job.new(job_params)
      @job.created_by = current_user
    if @job.save
      redirect_to @job
    else
      render 'new'
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :price, :date_of_job)
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

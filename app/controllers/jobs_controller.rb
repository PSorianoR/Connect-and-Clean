class JobsController < ApplicationController

  def index
    if session[:user_role] == "manager"
      profession = "management"
      get_job(profession)

    elsif session[:user_role] == "cleaner"
      profession = "cleaning"
      get_job(profession)
      filter_application_status
    end
  end

  def show
  end

  def new
    @job = Job.new
    @property = Property.find(params[:property_id])
    @properties = current_user.properties
  end

  def create
    @job = Job.new(job_params)
    @property = Property.find(params[:property_id])
    @job.property = @property
    @job.status = "Open"
    if @job.save!
      redirect_to property_jobs_path(@property), notice: 'Job was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
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

  private

  def job_params
    params.require(:job).permit(:title, :description, :price, :cleaning_from, :cleaning_until, :property)
  end
end

include ReviewsHelper

class JobsController < ApplicationController
  before_action :select_job, only: %i[show]

  def index
    if session[:user_role] == "manager"
      profession = "manager"
      get_job(profession)

    elsif session[:user_role] == "cleaner"
      profession = "cleaner"
      get_job(profession)
      add_job_all
      filter_application_status
    end
  end

  def show
  end

  def new
    @job = Job.new
    @properties = current_user.teams.where(profession: "manager").map(&:property)
  end

  def create
    @job = Job.new(job_params)
    @property = Property.find(params[:job][:property_id])
    @job.property = @property
    @job.status = "open"
    @job.user = current_user
    if @job.save!
      redirect_to jobs_path, notice: 'Job was successfully created.'
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
      unless @jobs.nil?
        @jobs.sort_by { |job| job.date_of_job.nil? ? Date.new(9999,12,31) : job.date_of_job }
      end
    end

  def filter_application_status
    @jobs = @jobs.reject do |job|
      job.job_applications.where(user_id: current_user.id, status: "rejected").exists? ||
      job.job_applications.where(status: ["accepted", "completed"]).where.not(user_id: current_user.id).exists?
    end
  end

  def add_job_all
    # Get all jobs where the 'post_all' field is true
    all_jobs = Job.where(post_all: true)
    # Exclude jobs that are already in @jobs
    new_jobs = all_jobs - @jobs

    # Add the new jobs to the @jobs array
    @jobs += new_jobs
  end

  def change_status
    puts "Change_status method called"
    job = Job.find(params[:format])
    if session[:user_role] == "cleaner"
      case job.status
      when "open"
        if job.property.teams.find_by(user: current_user, profession: "cleaner")
          JobApplication.create!(user: current_user, job: job, status: "accepted")
          job.status = "accepted"
          job.save!
        else
          JobApplication.create!(user: current_user, job: job, status: "applied")
          job.status = "applied"
          job.save!
        end
      when "accepted"
        job.status = "completed"
        job.save!
        appl = JobApplication.find_by(user: current_user, job: job)
        appl.status = "completed"
        appl.save!
      when "applied"
        if job.job_applications.find_by(user: current_user).nil?
          if job.property.teams.find_by(user: current_user, profession: "cleaner")
            JobApplication.create!(user: current_user, job: job, status: "accepted")
            job.status = "accepted"
            job.save!
          else
            JobApplication.create!(user: current_user, job: job, status: "applied")
          end
        end
      end
    else

    end
    redirect_to jobs_path
  end

  def accept_cleaner
    job = Job.find(params[:job_id])
    cleaner = User.find(params[:id])


    appl = JobApplication.find_by(job: job, user: cleaner)
    appl.status = "accepted"
    appl.save!

    job.status = "accepted"
    job.save!

    redirect_to jobs_path
  end

  def open
    index

    if session[:user_role] == "manager"
      @jobs = @jobs.select { |job| job.status == "open"}
      render partial: 'job_list', locals: { jobs: @jobs }
    else
      @jobs = @jobs.select do |job|
        notApplied = job.job_applications.none? do |appl|
          appl.user == current_user
        end
        notApplied
      end
      render partial: 'job_list', locals: { jobs: @jobs }
    end
  end

  def applied
    index

    if session[:user_role] == "manager"
      @jobs = @jobs.select { |job| job.status == "applied"}
      render partial: 'job_list', locals: { jobs: @jobs }
    else
      @jobs = @jobs.select do |job|
        hasApplied = job.job_applications.any? do |appl|
          appl.user == current_user && appl.status == "applied"
        end
        hasApplied
      end

      render partial: 'job_list', locals: { jobs: @jobs }
    end
  end

  def accepted
    index
    @jobs = @jobs.select { |job| job.status == "accepted"}
    render partial: 'job_list', locals: { jobs: @jobs }
  end

  def completed
    index
    @jobs = @jobs.select { |job| job.status == "completed"}
    render partial: 'job_list', locals: { jobs: @jobs }
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :price, :cleaning_from, :cleaning_until, :date_of_job, :post_all)
  end

  def select_job
    @job = Job.find(params[:id])
  end


  # def reject_applications(job)
  #   other_user_applications = job.job_applications.where.not(user: current_user)
  #   other_user_applications.each do |appl|
  #     appl.status = "rejected"
  #     appl.save!
  #   end
  # end

end

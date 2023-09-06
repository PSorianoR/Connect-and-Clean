class JobsController < ApplicationController
  def index
    @jobs = Job.all
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
end

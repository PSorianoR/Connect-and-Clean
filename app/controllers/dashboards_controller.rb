class DashboardsController < ApplicationController
  def index
    profession = session[:user_role]
    @jobs = get_completed_jobs(profession)

    @total_price = 0
    @jobs.each do |job|
      @total_price += job.price
    end

    # Actions to get filter on the dates, data is received from data_filter_controller.js
    from_date = params[:from_date]
    until_date = params[:until_date]

    filtered_jobs = @jobs.where(date_of_job: from_date..until_date)

    respond_to do |format|
      format.html  # Render the HTML view as usual
      format.json { render json: { jobs: filtered_jobs } } # Respond with JSON data
    end

  end

  private

  # Get all the jobs when the user is a manager
  def get_completed_jobs(profession)

    # Get all the completed jobs.
    completed_jobs = Job.joins(property: :teams)
                    .where(teams: { user_id: current_user.id, profession: profession })
                    .where(status: 'completed')

    # As a cleaner, you need an addtional filter to make sure you completed the job.

    if profession == "cleaner"
      completed_jobs = completed_jobs.joins(:job_applications)
                                  .where(job_applications: { status: "completed", user_id: current_user.id })
                                  .distinct
    end

    return completed_jobs
  end
end

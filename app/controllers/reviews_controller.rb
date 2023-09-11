class ReviewsController < ApplicationController
  before_action :get_review, only: %i[show]

  def new
    @job = Job.find(params[:job_id])
    @review = Review.new
  end

  def show
  end

  def create
    @job = Job.find(params[:job_id])
    @review = Review.new(review_params)
    @review.job = @job
    @review.user = current_user
    if @review.save!
      redirect_to jobs_path
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:description, :rating)
  end

  def get_review
    @review = Review.find(params[:id])
  end

end

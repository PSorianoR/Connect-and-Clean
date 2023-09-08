class ReviewsController < ApplicationController
  def new
    @job = Job.find(params[:job_id])
    @review = Review.new
  end

  def create
    @job = Job.find(params[:job_id])
    @review = Review.new(review_params)
    @review.job = @job
    @review.user = current_user
    if @review.save
      redirect_to new_job_review_path
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:description, :rating)
  end

end

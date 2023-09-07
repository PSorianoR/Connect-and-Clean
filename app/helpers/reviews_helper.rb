module ReviewsHelper
  def cleaner_review(job)
    # The job review will be the review for the cleaner for the job, it will therefore be written by the manager
    # The manager is added to the job as the creator.
    manager = job.user

    # Now find the review that the manager wrote about the job
    return job.reviews.find_by(user_id: manager.id)
  end

  def cleaner_all_reviews(cleaner)
    # This method returns all the reviews for the jobs that the user executed as a cleaner.
    applications = cleaner.job_applications.where(status:"completed")
    jobs = []
    applications.each do |applic|
      jobs << applic.job
    end
    reviews = jobs.map do |job|
      cleaner_review(job)
    end
    return reviews
  end

  def manager_review(job)
    # The job review will be the review for the cleaner for the job, it will therefore be written by the manager
    cleaner = job.job_applications.find_by(status: "completed").user

     # Now find the review that the manager wrote about the job
     return job.reviews.find_by(user_id: cleaner.id)
  end

  def manager_all_reviews(manager)
    # These are the all the reviews that cleaners wrote about the job that the manager created.
    jobs = manager.jobs.where(user: manager, status:"completed")

    reviews = jobs.map do |job|
      manager_review(job)
    end

    return reviews
  end

  def property_reviews(property)
    # These are all the reviews that cleaners wrote about the property.
    # It is therefore the review from the cleaner about the manager
    jobs = property.jobs.where(status: "completed")

    reviews = jobs.map do |job|
      manager_review(job)
    end

  end

end

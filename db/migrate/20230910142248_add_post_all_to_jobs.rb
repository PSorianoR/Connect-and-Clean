class AddPostAllToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :post_all, :boolean
  end
end

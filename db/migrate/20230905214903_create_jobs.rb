class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.float :price
      t.string :description
      t.string :status
      t.date :date_of_job
      t.string :cleaning_from
      t.string :cleaning_until
      t.references :property, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

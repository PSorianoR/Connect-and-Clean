class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :title
      t.string :description
      t.string :address
      t.float :default_job_price
      t.string :default_cleaning_from
      t.string :default_cleaning_until
      t.float :latitude
      t.float :longitude
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

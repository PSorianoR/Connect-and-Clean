class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|

      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.string :type, null: false

      t.timestamps
    end
  end
end

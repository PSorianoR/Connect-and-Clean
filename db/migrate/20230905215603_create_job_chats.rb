class CreateJobChats < ActiveRecord::Migration[7.0]
  def change
    create_table :job_chats do |t|
      t.references :job, null: false, foreign_key: true
      t.references :chatroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end

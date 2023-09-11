class DropJobMessages < ActiveRecord::Migration[7.0]
  def change
    drop_table :job_messages
  end
end

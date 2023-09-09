class RenameJobChatToJobMessages < ActiveRecord::Migration[7.0]
  def change
    rename_table :job_chats, :job_messages
  end
end

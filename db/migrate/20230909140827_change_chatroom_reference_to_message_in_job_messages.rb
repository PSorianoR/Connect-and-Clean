class ChangeChatroomReferenceToMessageInJobMessages < ActiveRecord::Migration[7.0]
  def change
    remove_reference :job_messages, :chatroom, index: true, foreign_key: true
    add_reference :job_messages, :message, foreign_key: true
  end
end

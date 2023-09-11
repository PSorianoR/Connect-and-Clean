class AddProfessionToChatroomMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :chatroom_members, :profession, :string
  end
end

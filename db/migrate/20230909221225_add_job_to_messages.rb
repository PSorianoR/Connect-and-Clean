class AddJobToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :job, foreign_key: true
  end
end

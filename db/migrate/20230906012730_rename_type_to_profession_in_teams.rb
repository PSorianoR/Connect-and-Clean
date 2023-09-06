class RenameTypeToProfessionInTeams < ActiveRecord::Migration[7.0]
  def change
    rename_column :teams, :type, :profession
  end
end

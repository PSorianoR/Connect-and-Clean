class AddCoordinatesToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :latitude, :float
    add_column :properties, :longitude, :float
    remove_column :properties, :lat
    remove_column :properties, :long
  end
end

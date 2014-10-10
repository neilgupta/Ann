class ConvertToSensorType < ActiveRecord::Migration
  def change
    rename_column :motors, :type, :motor_type
    rename_column :sensors, :type, :sensor_type
  end
end

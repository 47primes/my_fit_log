class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.timestamp :completed_at
      t.string :summary
      t.timestamps
    end
  end
end

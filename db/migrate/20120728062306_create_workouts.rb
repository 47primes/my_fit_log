class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.integer :user_id
      t.timestamp :completed_at
      t.string :summary
      t.timestamps
    end
  end
end

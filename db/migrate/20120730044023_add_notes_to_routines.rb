class AddNotesToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :notes, :text
  end
end

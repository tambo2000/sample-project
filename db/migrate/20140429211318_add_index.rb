class AddIndex < ActiveRecord::Migration
  def change
    add_index :tasks, :project_id
  end
end

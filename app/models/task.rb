class Task < ActiveRecord::Base
  validates :project_id, :name, :difficulty_level, presence: true

  belongs_to :project
end

class Project < ActiveRecord::Base

  # simpler version:
  has_many :project_users
  has_many :users, through: :project_users
  has_many :tasks, dependent: :destroy

  # complicated version: 
  has_many :project_viewers, class_name: :ProjectUser, conditions: {role: ProjectUser::ROLE[:viewer]}
  has_many :viewers, source: :user, through: :project_viewers

  has_many :project_owners, class_name: :ProjectUser, conditions: {role: ProjectUser::ROLE[:owner]}
  has_many :owners, source: :user, through: :project_owners
end

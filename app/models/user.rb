class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :project_users
  has_many :projects, through: :project_users, uniq: true


  ROLE = {
    user: 1,
    admin: 100
  }

  def name
    "#{fname} #{lname}"
  end

  # def projects
  #   if current_user.role == User::ROLE[:admin]
  #     Project.all
  #   else
  #     user_projects
  #   end
  # end



end

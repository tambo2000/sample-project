class ProjectUsersController < ApplicationController
  def create
    @project_user = ProjectUser.new(project_user_params)
    @project_user.user_id = params[:user_id]
    if @project_user.save
      redirect_to project_url(id: @project_user.project_id)
    end
  end

  private

  def project_user_params
      params.require(:project_user).permit(:user_id, :project_id, :role)
  end

end

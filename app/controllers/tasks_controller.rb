class TasksController < ApplicationController
  before_filter :authorize_edit, only: [:edit, :update, :destroy, :create], unless: :admin?
  before_filter :authorize_view, only: [:show, :edit, :update, :destroy], unless: :admin?

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.create(task_params)
    if @task.save
      redirect_to project_url(@task.project_id), notice: 'Task was successfully created.'
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :difficulty_level, :project_id)
  end

  def authorize_edit
      @task = Task.new(task_params)
      @project = Project.find(@task.project_id)
      if !@project.owners.include?(current_user)
        redirect_to projects_url(current_user), notice: 'You are not authorized to modify this task'
      end
    end

    def authorize_view
      @task = Task.new(task_params)
      @project = Project.find(@task.project_id)
      if !@project.viewers.include?(current_user)
        redirect_to projects_url(current_user), notice: 'You are not authorized to view this task'
      end
    end
end

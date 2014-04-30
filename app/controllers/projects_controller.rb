class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  before_filter :authorize_edit, only: [:edit, :update, :destroy], unless: :admin?
  before_filter :authorize_view, only: [:show, :edit, :update, :destroy], unless: :admin?



  # GET /projects
  # GET /projects.json
  def index
    if current_user.role == User::ROLE[:admin]
      @projects = Project.all.page(params[:page]).per(10)
    else
      @projects = current_user.projects.page(params[:page]).per(10)
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @tasks = @project.tasks
    @task = Task.new
    @task.project_id = @project.id
    @project_user = ProjectUser.new
    @project_user.project_id = @project.id
    
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        @project_user_owner = ProjectUser.new({project_id: @project.id, user_id: current_user.id, role: ProjectUser::ROLE[:owner]})
        @project_user_viewer = ProjectUser.new({project_id: @project.id, user_id: current_user.id, role: ProjectUser::ROLE[:viewer]})
        if @project_user_owner.save && @project_user_viewer.save
          format.html { redirect_to @project, notice: 'Project was successfully created.' }
          format.json { render action: 'show', status: :created, location: @project }
        else
          format.html { render action: 'new' }
          format.json { render json: (@project_user_owner.errors + @project_user_viewer.errors), status: :unprocessable_entity }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end

    def authorize_edit
      @project = Project.find(params[:id])
      if !@project.owners.include?(current_user)
        redirect_to projects_url(current_user), notice: 'You are not authorized to modify this project'
      end
    end

    def authorize_view
      @project = Project.find(params[:id])
      if !@project.viewers.include?(current_user)
        redirect_to projects_url(current_user), notice: 'You are not authorized to view this project'
      end
    end
end

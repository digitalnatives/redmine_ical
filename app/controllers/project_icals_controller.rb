class ProjectIcalsController < ApplicationController
  unloadable

  def show
    project = Project.find(params[:project_id])
    send_file project.cal_filename
  end
end

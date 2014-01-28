class ProjectIcalsController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :check_token

  def find_project
    @project = Project.find_by_identifier(params[:project_id])
  end

  def check_token
    token = IcalDownloadToken.where(project_id: @project.id, token: params[:token]).first
    render_403 if token.expired?
  end

  def show
    send_file @project.cal_filename
  end
end

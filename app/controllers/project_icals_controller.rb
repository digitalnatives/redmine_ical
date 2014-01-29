class ProjectIcalsController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :check_token

  def find_project
    @project = Project.find_by_identifier(params[:project_id])
  end

  def check_token
    token = @project.ical_download_tokens.where(token: params[:token])
    render_403 unless token.present?
  end

  def show
    send_file @project.cal_filename
  end
end

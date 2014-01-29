class ProjectIcalsController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :check_token

  def find_project
    @project = Project.find_by_identifier(params[:project_id])
  end

  def check_token
    valid_token = @project.valid_ical_tokens.where(token: params[:token])
    render_403 unless valid_token.present?
  end

  def show
    send_file @project.cal_filename
  end
end

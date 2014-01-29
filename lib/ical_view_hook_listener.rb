class IcalViewHookListener < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, :partial => 'issues/custom_attributes'
  render_on :view_issues_form_details_head, :partial => 'hooks/rb_include_scripts'
  render_on :view_projects_show_left, :partial => 'projects/ical_box'
end

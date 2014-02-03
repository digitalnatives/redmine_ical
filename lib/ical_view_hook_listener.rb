class IcalViewHookListener < Redmine::Hook::ViewListener
  render_on :view_layouts_base_html_head, :partial => 'hooks/ri_include_scripts'
  render_on :view_issues_form_details_bottom, :partial => 'issues/ri_custom_attributes'
  render_on :view_projects_show_left, :partial => 'projects/ical_box'
end

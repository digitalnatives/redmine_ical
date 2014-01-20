class IcalViewHookListener < Redmine::Hook::ViewListener
  render_on :view_issues_form_details_bottom, :partial => 'issues/custom_attributes'
end

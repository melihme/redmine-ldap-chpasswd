class LDAPChangePasswordHook < Redmine::Hook::ViewListener

  #include ApplicationHelper
  
  def view_my_account(context = {})
    user = context[:user]
    f = context[:view_account_left_bottom]
    return '' unless user
    o = '<fieldset class="box tabular">'
    o << '<legend>' << l(:label_change_password) << '</legend>'
    o << "<p><label for=\"user_password\">"<< l(:label_current_password) <<"</label><input type=\"password\" name=\"old_password\" id=\"user_password\" style=\"width:90%\" /></p>"
    o << "<p><label for=\"new_password\">" << l(:label_new_password) << "</label><input type=\"password\" name=\"new_password\" id=\"new_password\" style=\"width:90%\" /></p>"
    o << "<p><label for=\"confirm_password\">" << l(:label_new_password_again) << "</label><input type=\"password\" name=\"confirm_new_password\" id=\"confirm_password\" style=\"width:90%\" /></p>"
    o << '</fieldset>'
    return o

  end


end

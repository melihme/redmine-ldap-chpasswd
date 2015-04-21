require 'digest/sha1'
require 'base64'

module RedmineLdapChangePasswordPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :account, :ldap_support
    end
  end

  module InstanceMethods

    def account_with_ldap_support
      @user = User.current
      @pref = @user.pref
      if request.post?
        @user.safe_attributes = params[:user]
        @user.pref.attributes = params[:pref]
        @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
        ldap_password =  params[:old_password]
        ldap_new_password =  params[:new_password]
        ldap_confirm_password =  params[:confirm_new_password]
        if !ldap_password.empty? && !ldap_new_password.empty?
          self.change_ldap_password(ldap_password, ldap_new_password)
        end
        if @user.save
          @user.pref.save
          @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
          set_language_if_valid @user.language
        #  flash[:notice] = l(:notice_account_updated)
          redirect_to :action => 'account'
          return
        end
      end      
    end#account_with_ldap_support

    def change_ldap_password(password, newpass)
      authSource = AuthSource.find(@user.auth_source_id)
      login = "uid=#{@user.login}"
      treebase = authSource.base_dn
      ldap = Net::LDAP.new 
      ldap.host = authSource.host
      ldap.base = "#{treebase}"
      ldap.port = authSource.port
      ldap.auth "#{login},#{treebase}", password
      if ldap.bind
        e_password = "{SHA}" + Base64.encode64(Digest::SHA1.digest(newpass)).chomp
        # Do the modification
        ldap.replace_attribute "#{login},#{treebase}", :userPassword, e_password
        flash[:notice] = l(:notice_update_successful) #Password update successful
      else
        flash[:error] = l(:error_can_not_bind_the_ldap_server, :login => login, :treebase => ldap.base) #Cannot bind to LDAP server! (User) %{login},%{treebase}
      end
    end#change_ldap_password

  end#module InstanceMethods  

end#module RedmineLdapChangePasswordPatch

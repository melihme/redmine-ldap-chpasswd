require 'redmine'
require 'net/ldap'
require 'redmine_ldap_chpasswd_viewhook'
require 'redmine_ldap_chpasswd_patch'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'my_controller'
  unless MyController.included_modules.include? RedmineLdapChangePasswordPatch
    MyController.send(:include, RedmineLdapChangePasswordPatch)
  end 
end

Redmine::Plugin.register :redmine_ldap_chpasswd do
  name 'Redmine LDAP Change Password plugin'
  author 'Melih Taşdizen <melih@miletos.co>'
  description 'This is a Redmine\'s plugin for change password of users who authenticating via LDAP. This version forked from Thao Le Thach's work.'
  version '0.0.2'
  url 'https://github.com/melihme/redmine-ldap-chpasswd'
  author_url 'https://github.com/melihme'
end

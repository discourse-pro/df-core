# name: df-core
# about: A common functionality of my Discourse plugins.
# version: 1.0.0
# authors: Dmitry Fedyuk
# url: https://discourse.pro
register_asset 'javascripts/admin.js', :admin
require 'site_setting_extension'
SiteSettingExtension.module_eval do
	alias_method :core__types, :types
	def types
		result = @types
		if not result
			result = core__types
			result[:df_editor] = result.length + 1;
			result[:paypal_buttons] = result.length + 1;
			result[:paid_membership_plans] = result.length + 1;
		end
		return result
	end
end
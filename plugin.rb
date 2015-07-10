# name: df-core
# about: A common functionality of my Discourse plugins.
# version: 1.0.0
# authors: Dmitry Fedyuk
# url: https://discourse.pro
register_asset 'javascripts/admin.js', :admin
register_asset 'stylesheets/main.scss'
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
require 'plugin/instance'
Plugin::Instance.class_eval do
	def df_gem(name, version)
		gems_path = File.dirname(path) + "/gems/#{RUBY_VERSION}"
		spec_path = gems_path + "/specifications"
		spec_file = spec_path + "/#{name}-#{version}.gemspec"
		puts "spec_file: #{spec_file}"
		spec = Gem::Specification.load spec_file
		spec.activate
		require name
	end
end
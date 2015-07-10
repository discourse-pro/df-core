# name: df-core
# about: A common functionality of my Discourse plugins.
# version: 1.0.0
# authors: Dmitry Fedyuk
# url: https://discourse.pro
register_asset 'javascripts/admin.js', :admin
register_asset 'stylesheets/main.scss'
# Из коробки airbrake не устанавливается.
# Поэтому чуточку подправил его и устанавливаю локальную версию.
spec_file = "#{Rails.root}/plugins/df-core/gems/2.2.2/specifications/airbrake-4.3.0.gemspec"
spec = Gem::Specification.load spec_file
spec.activate
require 'airbrake'
Airbrake.configure do |config|
  config.api_key = 'c07658a7417f795847b2280bc2fd7a79'
  config.host    = 'log.dmitry-fedyuk.com'
  config.port    = 80
  config.secure  = config.port == 443
  config.development_environments = []
end
gem 'attr_required', '1.0.0'
gem 'paypal-express', '0.8.1', {require_name: 'paypal'}
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
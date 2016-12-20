# name: df-core
# about: A common functionality of my Discourse plugins.
# version: 1.2.0
# authors: Dmitry Fedyuk
# url: https://discourse.pro
#register_asset 'javascripts/lib/sprintf.js'
register_asset 'javascripts/admin.js', :admin
register_asset 'lib/magnific-popup/main.js'
register_asset 'stylesheets/main.scss'
pluginAppPath = "#{Rails.root}/plugins/df-core/app/"
Discourse::Application.config.autoload_paths += Dir["#{pluginAppPath}models", "#{pluginAppPath}controllers"]
# 2016-12-20
# Sentry exception tracking software
# https://docs.sentry.io/clients/ruby/integrations/rails/#installation
gem 'sentry-raven', '2.2.0'
Raven.configure do |c|
	# 2016-12-20
	# https://github.com/getsentry/raven-ruby/blob/v2.2.0/README.md#raven-only-runs-when-sentry_dsn-is-set
	c.dsn = 'https://f2e17450e7824057a25ec9f1685afc36:55d6ce963ec64c5897277510fb2c011e@sentry.io/123623'
end
=begin
2016-12-19
Используется из dfg-paypal:
https://github.com/discourse-pro/dfg-paypal/blob/0.8.2/lib/paypal/nvp/request.rb#L4
https://github.com/discourse-pro/dfg-paypal/blob/0.8.2/lib/paypal/payment/response/reference.rb#L4
=end
gem 'attr_required', '1.0.0'
# 2016-12-12
# Оригинальный https://github.com/nov/paypal-express перестал работать:
# https://github.com/nov/paypal-express/issues/99
# Мой гем: https://rubygems.org/gems/dfg-paypal
# https://github.com/discourse-pro/dfg-paypal
gem 'dfg-paypal', '0.8.2', {require_name: 'paypal'}
Paypal::Util.module_eval do
=begin
	2015-07-10
	Чтобы гем не передавал параметры со значением "0.00"
	(чувствую, у меня из-за них пока не работает...)
	{
	  "PAYERID" => "UES9EX5HHA8ZJ",
	  "PAYMENTREQUEST_0_AMT" => "0.00",
	  "PAYMENTREQUEST_0_PAYMENTACTION" => "Sale",
	  "PAYMENTREQUEST_0_SHIPPINGAMT" => "0.00",
	  "PAYMENTREQUEST_0_TAXAMT" => "0.00",
	  "TOKEN" => "EC-6MJ94873BM276735F"
	}
=end
	def self.formatted_amount(x)
		result = sprintf("%0.2f", BigDecimal.new(x.to_s).truncate(2))
		'0.00' == result ? '' : result
	end
end
Paypal::NVP::Request.module_eval do
	def post(method, params)
		allParams = common_params.merge(params).merge(:METHOD => method)
		# 2016-12-20
		# https://docs.sentry.io/clients/ruby/context/
		Raven.capture_message "POST #{method}",
			extra: allParams.merge('URL' => self.class.endpoint),
			level: 'debug',
			server_name: Discourse.current_hostname
		RestClient.post(self.class.endpoint, allParams)
	end
	alias_method :core__request, :request
	def request(method, params = {})
		# http://stackoverflow.com/a/4686157
		if :SetExpressCheckout == method
			# 2015-07-10
			# Это поле обязательно для заполнение, однако гем его почему-то не заполняет.
			# «Version of the callback API.
			# This field is required when implementing the Instant Update Callback API.
			# It must be set to 61.0 or a later version.
			# This field is available since version 61.0.»
			# https://developer.paypal.com/docs/classic/api/merchant/SetExpressCheckout_API_Operation_NVP/#localecode
			params[:CALLBACKVERSION] = self.version
		end
		core__request method, params
	end
end
require 'site_setting_extension'
SiteSettingExtension.module_eval do
	alias_method :core__types, :types
	def types
		result = @types
		if not result
			result = core__types
			result[:df_editor] = result.length + 1;
			# 2015-08-31
			# input type=password
			result[:df_password] = result.length + 1;
			# 2015-08-27
			# textarea без редактора
			result[:df_textarea] = result.length + 1;
			result[:paypal_buttons] = result.length + 1;
			result[:paid_membership_plans] = result.length + 1;
		end
		return result
	end
end
after_initialize do
	module ::Df::Core
		class Engine < ::Rails::Engine
			engine_name 'df_core'
			isolate_namespace ::Df::Core
		end
	end
	::Df::Core::Engine.routes.draw do
		get '/thumb/:width/:height' => 'thumb#index'
	end
	Discourse::Application.routes.append do
		mount ::Df::Core::Engine, at: '/df/core'
	end	
end
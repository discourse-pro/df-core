# name: df-core
# about: A common functionality of my Discourse plugins.
# version: 1.0.0
# authors: Dmitry Fedyuk
# url: https://discourse.pro
#register_asset 'javascripts/lib/sprintf.js'
register_asset 'javascripts/admin.js', :admin
register_asset 'javascripts/admin/editor.js', :admin
register_asset 'lib/magnific-popup/main.js'
register_asset 'stylesheets/main.scss'
pluginAppPath = "#{Rails.root}/plugins/df-core/app/"
Discourse::Application.config.autoload_paths += Dir["#{pluginAppPath}models", "#{pluginAppPath}controllers"]
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
		Airbrake.notify(
			:error_message => "POST #{method}",
			:parameters => allParams.merge('URL' => self.class.endpoint)
		)
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
	# 2015-07-19
	# Добавляем поддержку логирования при выполнении JavaScript на сервере
	require 'pretty_text'
	PrettyText.module_eval do
		class << self
			alias_method :_decorate_context, :decorate_context
			def decorate_context(context)
				# https://github.com/cucumber/gherkin/blob/4d6c049cc75d154e1cf660794a078570e8aa7849/lib/gherkin/native/therubyracer.rb#L26-L30
				context['console'] = STDOUT
				def STDOUT.log(*a)
					message = sprintf(*a.map(&:to_s))
					puts message
					Airbrake.notify(:error_message => message)
				end
				_decorate_context context
			end
		end
	end
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
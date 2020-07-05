# name: df-core
# about: A common functionality of my Discourse plugins.
# version: 1.4.1
# authors: Dmitry Fedyuk
# url: https://discourse.pro
#register_asset 'javascripts/lib/sprintf.js'
register_asset 'javascripts/admin.js', :admin
register_asset 'lib/magnific-popup/main.js'
register_asset 'stylesheets/main.scss'
pluginAppPath = "#{Rails.root}/plugins/df-core/app/"
Discourse::Application.config.autoload_paths += Dir["#{pluginAppPath}models", "#{pluginAppPath}controllers"]
# 2018-01-12
# 1) "«NameError: uninitialized constant SiteSettings::DefaultsProvider::DistributedCache»
# on `bundle exec rake db:migrate` after upgrading to Discourse v1.9.0.beta11":
# https://github.com/discourse-pro/df-core/issues/1
# 2) "Why does the `SiteSettings` class use the `DistributedCache`
# without a `require 'distributed_cache';` statement?": https://meta.discourse.org/t/77580
require 'distributed_cache'
require 'site_setting_extension'
if defined?(SiteSettings::TypeSupervisor)
	SiteSettings::TypeSupervisor.module_eval do
		class <<self
			alias_method :core__types, :types
			def types
				result = @types
				if not result
					result = core__types
					result[:df_editor] = 500;
					result[:df_password] = 501; # 2015-08-31 input type=password
					result[:df_textarea] = 502; # 2015-08-27 textarea без редактора
					result[:paypal_buttons] = 503;
					result[:paid_membership_plans] = 504;
				end
				return result
			end
		end
		alias_method :core__to_rb_value, :to_rb_value
		def to_rb_value(name, value, override_type = nil)
			begin
			  result = core__to_rb_value(name, value, override_type)
			rescue ArgumentError
			  result = value
			end
			return result
		end
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
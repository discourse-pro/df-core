# name: df-core
# about: A common functionality of my Discourse plugins.
# version: 1.5.1
# authors: Dmitry Fedyuk
# url: https://discourse.pro
#register_asset 'javascripts/lib/sprintf.js'
register_asset 'stylesheets/main.scss'
# 2018-01-12
# 1) "«NameError: uninitialized constant SiteSettings::DefaultsProvider::DistributedCache»
# on `bundle exec rake db:migrate` after upgrading to Discourse v1.9.0.beta11":
# https://github.com/discourse-pro/df-core/issues/1
# 2) "Why does the `SiteSettings` class use the `DistributedCache`
# without a `require 'distributed_cache';` statement?": https://meta.discourse.org/t/77580
require 'distributed_cache'
require 'site_settings/validations'
require 'site_settings/type_supervisor'
SiteSettings::TypeSupervisor.module_eval do
	# 2020-07-06
	# «rake aborted!» / «ArgumentError: type» / «lib/site_settings/type_supervisor.rb:112:in `to_rb_value'»
	# on `bundle exec rake db:migrate`: https://github.com/discourse-pro/df-core/issues/2
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
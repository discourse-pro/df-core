module ::Df::Core::Enum::Currency
	require_dependency 'enum_site_setting'
	class Paypal < EnumSiteSetting
		def self.valid_value?(val)
			val.blank? or values.any? { |v| v[:value] == val.to_s }
		end
		def self.values
			@values ||= [
				{name: 'Australian Dollar', value: 'AUD'},
				{name: 'Brazilian Real', value: 'BRL'},
				{name: 'Canadian Dollar', value: 'CAD'},
				{name: 'Czech Koruna', value: 'CZK'},
				{name: 'Danish Krone', value: 'DKK'},
				{name: 'Euro', value: 'EUR'},
				{name: 'Hong Kong Dollar', value: 'HKD'},
				{name: 'Hungarian Forint', value: 'HUF'},
				{name: 'Israeli New Sheqel', value: 'ILS'},
				{name: 'Japanese Yen ', value: 'JPY'},
				{name: 'Malaysian Ringgit ', value: 'MYR'},
				{name: 'Mexican Peso', value: 'MXN'},
				{name: 'Norwegian Krone', value: 'NOK'},
				{name: 'New Zealand Dollar', value: 'NZD'},
				{name: 'Philippine Peso', value: 'PHP'},
				{name: 'Polish Zloty', value: 'PLN'},
				{name: 'Pound Sterling', value: 'GBP'},
				{name: 'Russian Ruble', value: 'RUB'},
				{name: 'Singapore Dollar', value: 'SGD'},
				{name: 'Swedish Krona', value: 'SEK'},
				{name: 'Swiss Franc', value: 'CHF'},
				{name: 'Taiwan New Dollar ', value: 'TWD'},
				{name: 'Thai Baht', value: 'THB'},
				{name: 'Turkish Lira', value: 'TRY'},
				{name: 'U.S. Dollar', value: 'USD'}
			]
		end
		def self.translate_names?
			false
		end
	end
end

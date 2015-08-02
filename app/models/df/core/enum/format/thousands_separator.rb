module ::Df::Core::Enum::Format
	require_dependency 'enum_site_setting'
	class ThousandsSeparator < EnumSiteSetting
		def self.valid_value?(val)
			val.blank? or values.any? { |v| v[:value] == val.to_s }
		end
		def self.values
			@values ||= [
				{name: 'df.core.enum.format.thousands_separator.none', value: 'none'},
				{name: 'df.core.enum.format.thousands_separator.thin_space', value: 'thin_space'},
				{name: 'df.core.enum.format.thousands_separator.comma', value: ','},
				{name: 'df.core.enum.format.thousands_separator.period', value: '.'}
			]
		end
		def self.translate_names?
			true
		end
	end
end

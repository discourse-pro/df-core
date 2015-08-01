module ::Df::Core::Enum::Position
	require_dependency 'enum_site_setting'
	class BeforeAfter < EnumSiteSetting
		def self.valid_value?(val)
			val.blank? or values.any? { |v| v[:value] == val.to_s }
		end
		def self.values
			@values ||= [
				{name: 'df.core.enum.position.before', value: 'before'},
				{name: 'df.core.enum.position.after', value: 'after'}
			]
		end
		def self.translate_names?
			true
		end
	end
end

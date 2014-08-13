module TMS
	class Link
		attr_accessor :qualifier, :secondary_qualifier, :base
		
		def initialize(qualifier, base, secondary_qualifier = nil)
			@qualifier = qualifier
			@secondary_qualifier = secondary_qualifier
			@base = base
		end
	end
end
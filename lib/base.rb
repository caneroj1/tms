module TMS
	class Base
		attr_accessor :links, :noun

		def initialize(noun)
			@links = []
			@noun = noun
		end

		def create_link(link)
			@links.push(link)
		end

		def describe
			result = ""
			@links.each do |link|
				result << "#{link.qualifier} #{@noun} are "
				result << "not " if !link.secondary_qualifier.nil?
				result << "#{link.base.noun}.\n"
			end
			result
		end
	end
end
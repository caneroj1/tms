require_relative 'parser.rb'

module TMS
	class Engine
		def self.start
			parser = TMS::Parser.new
			loop do
				print "> "
				input = gets.strip.chomp.downcase
				break if input.eql?("end")
				result = parser.parse(input)
				puts !result.nil? ? "#{result}" : "Error: bad input."
			end
		end
	end
end
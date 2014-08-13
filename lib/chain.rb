require_relative 'base.rb'
require_relative 'link.rb'

module TMS
	class Chain
		attr_accessor :bases

		def initialize
			@bases = []
		end

		def all(tokens)
			bases = prepare_data(tokens, false)
			link = TMS::Link.new(tokens[0], bases[1])
			bases[0].create_link(link)
			@bases.push(bases[0], bases[1])
			"OK!"
		end

		def no(tokens)
			bases = prepare_data(tokens, false)
			link = TMS::Link.new(tokens[0], bases[1])
			bases[0].create_link(link)
			@bases.push(bases[0], bases[1])
			"Got it!"
		end

		def some(tokens)
			some_not = tokens.count.eql?(5)
			bases = prepare_data(tokens, some_not)
			link = TMS::Link.new(tokens[0], bases[1], some_not ? "not" : nil)
			bases[0].create_link(link)
			@bases.push(bases[0], bases[1])
			"I know that now!"
		end

		def describe(tokens)
			base = @bases.index { |b| b.noun.eql?(tokens[1]) }
			@bases[base].describe
		end

		private
		def prepare_data(tokens, is_some_not_asssertion)
			ind_1 = @bases.index { |b| b.noun.eql?(tokens[1]) }
			pos = is_some_not_asssertion ? 4 : 3
			ind_2 = @bases.index { |b| b.noun.eql?(tokens[pos]) }

			base_1 = ind_1.nil? ? TMS::Base.new(tokens[1]) : @bases.delete_at(ind_1)
			base_2 = ind_2.nil? ? TMS::Base.new(tokens[pos]) : @bases.delete_at(ind_2)
			
			[base_1, base_2]
		end
	end
end
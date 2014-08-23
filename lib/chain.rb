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
			add_to_graph(tokens, bases)
			"OK!"
		end

		def no(tokens)
			bases = prepare_data(tokens, false)
			add_to_graph(tokens, bases)
			"Got it!"
		end

		def some(tokens)
			some_not = tokens.count.eql?(5)
			bases = prepare_data(tokens, some_not)
			add_to_graph(tokens, bases)
			"I know that now!"
		end

		def query(tokens)
			if !tokens[1].eql?("any")
				case tokens[1]
				when "all"
					all_query(tokens)
				when "no"
					no_query(tokens)
				end
			else
				some_query(tokens)
			end
		end

		def all_query(tokens)
			base = @bases[@bases.index { |b| b.noun.eql?(tokens[2]) }]
			base.links[tokens[3]].qualifier.eql?("all")
		end

		def no_query(tokens)
			base = @bases[@bases.index { |b| b.noun.eql?(tokens[2]) }]
			base.links[tokens[3]].qualifier.eql?("no")
		end

		def some_query(tokens)
			base = @bases[@bases.index { |b| b.noun.eql?(tokens[2]) }]
			params = !tokens.count.eql?(5) ? [3, nil] : [4, "not"]
			base.links[tokens[params[0]]].qualifier.eql?("some") && base.links[tokens[params[0]]].secondary_qualifier.eql?(params[1])
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
			
			[base_1, base_2, ind_1.nil?, ind_2.nil?]
		end

		def complete_graph(bases, new_link) 
			qualifiers = { "all" => 2, "some" => 1, "no" => 0 }

			if bases[2] ^ bases[3]
				old_base = bases[2] ? bases[1] : bases[0]
				new_base = bases[2] ? bases[0] : bases[1]

				old_base.links.select { |key, link| link != new_link }.each_pair do |key, link|
					qualifier = qualifiers[link.qualifier] <= qualifiers[new_link.qualifier] ? link.qualifier : new_link.qualifier
					new_base.create_link(TMS::Link.new(qualifier, link.base, new_link.secondary_qualifier))
					link.base.create_link(TMS::Link.new(qualifier, new_base, new_link.secondary_qualifier))
				end
			end
		end

		def add_to_graph(tokens, bases)
			link_1 = TMS::Link.new(tokens[0], bases[1], tokens.count.eql?(5) ? "not" : nil)
			link_2 = TMS::Link.new(tokens[0], bases[0], tokens.count.eql?(5) ? "not" : nil)
			bases[0].create_link(link_1)
			bases[1].create_link(link_2)
			@bases.push(bases[0], bases[1])
			complete_graph(bases, link_1)
		end
	end
end
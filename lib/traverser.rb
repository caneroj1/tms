require_relative 'base.rb'
require_relative 'link.rb'

module TMS
	class Traverser
		public
		attr_reader :qualifier, :secondary_qualifier, :bases, :subject, :target

		def initialize(qualifier, secondary_qualifier, bases, subject, target)
			type_str = secondary_qualifier.nil? qualifier.downcase : qualifier + secondary_qualifier
			raise "The type of traversal specified is invalid." if !traverser_type_correct(type_str + "?")
			
			@subject, @target, @bases = subject, target, bases
		end

		def traverse
			subject = find_subject(subject)
			raise "could not find the noun: #{subject}" if subject.nil?
			
			@queue.push(subject)
			search
		end

		private
		attr_accessor :parents, :discovered, :processed, :queue

		def traverser_type_correct(type)
			type.eql?("are any?") || type.eql?("are no?") || type.eql?("are any not?") || type.eql?("are all?")
		end

		def search
			while !@queue.empty?
				subject = @queue.pop

				@discovered[subject.noun] = true

				process_early(subject)

				links = subject.links.each do |link|
					if !@discovered[link.base.noun]
						@queue.push(link.base)
						@parents[link.base.noun] = subject.noun
						@discovered[link.base.noun] = true
					end
				end

				process_late(subject)
				@processed[subject.noun] = true
			end
		end

		def find_subject(subject)
			ind = @bases.index { |b| b.noun.eql?(subject) }
			@bases[ind]
		end
	end
end
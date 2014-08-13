require_relative 'chain.rb'

module TMS
	class Parser
		# ASSERTIONS ##########################
		# All PLURAL-NOUN are PLURAL-NOUN.
		# No PLURAL-NOUN are PLURAL-NOUN.
		# Some PLURAL-NOUN are PLURAL-NOUN.
		# Some PLURAL-NOUN are not PLURAL-NOUN.

		# QUERIES #############################
		#	Are all PLURAL-NOUN PLURAL-NOUN?
		# Are no PLURAL-NOUN PLURAL-NOUN?
		# Are any PLURAL-NOUN PLURAL-NOUN?
		# Are any PLURAL-NOUN not PLURAL-NOUN?
		# Describe PLURAL-NOUN.

		def initialize
			@chain = TMS::Chain.new
		end

		def parse(phrase)
			if query?(phrase)
				parse_query(phrase)
			elsif assertion?(phrase)
				parse_assertion(phrase)
			else
				nil
			end
		end

		def parse_assertion(phrase)
			tokens = phrase.gsub(/[.|?]/, "").split(" ")
			if assert_tokens_correct(tokens)
				@chain.send(tokens[0].to_sym, tokens)
			else
				nil
			end
		end

		def parse_query(phrase)
			tokens = phrase.gsub(/[.|?]/, "").split(" ")
			@chain.send(tokens[0].to_sym, tokens)
		end
		
		private
		def assert_tokens_correct(tokens)
			if tokens.include?("all") || tokens.include?("no")
				(tokens.include?("are") && tokens.count.eql?(4) &&
				(tokens[0].eql?("all") || tokens[0].eql?("no")) && 
				tokens[2].eql?("are"))
			elsif tokens.include?("some")
				(tokens.include?("are") && !tokens.include?("not") && tokens.count.eql?(4) &&
				tokens[0].eql?("some") && tokens[2].eql?("are")) ||
				(tokens.include?("are") && tokens.include?("not") && tokens.count.eql?(5) &&
				tokens[0].eql?("some") && tokens[2].eql?("are") && tokens[3].eql?("not"))
			else
				false
			end
		end

		def query?(phrase)
			/are.*\?/.match(phrase) || /describe.*\./.match(phrase)
		end

		def assertion?(phrase)
			 /[all|no|some].*\./.match(phrase)
		end
	end
end
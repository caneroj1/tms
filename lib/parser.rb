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
				parse_input(phrase, 0)
			elsif assertion?(phrase)
				parse_input(phrase, 1)
			else
				nil
			end
		end

		def parse_input(phrase, switch)
			tokens = tokenize_query(phrase)
			input_correct?(phrase, switch) ? @chain.send(tokens[0].to_sym, tokens) : nil
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

		def query_tokens_correct(tokens)
			if tokens.include?("are")
				(tokens.[1].eql?("all") && tokens.count.eql?(4)) || (tokens[1].eql?("no") && tokens.count.eql?(4)) ||
				(tokens.[1].eql?("any") && tokens.count.eql?(4) && !tokens.include?("not")) ||
				(tokens.[1].eql?("any") && tokens.count.eql?(5) && tokens[3].eql?("not"))
			elsif tokens.include?("describe")
				tokens.count.eql?(2)
			else
				false
			end
		end

		def input_correct?(tokens, switch)
			(query_tokens_correct(tokens) && switch.eql?(0)) || (assert_tokens_correct(tokens) && switch.eql?(1))
		end

		def tokenize_query(phrase)
			phrase.gsub(/[.|?]/, "").split(" ")
		end

		def query?(phrase)
			/are.*\?/.match(phrase) || /describe.*\./.match(phrase)
		end

		def assertion?(phrase)
			 /[all|no|some].*\./.match(phrase)
		end
	end
end
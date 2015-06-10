require './RandomResponder'
require './Responder'
require './WhatResponder'
require './PatternResponder'
require './TemplateResponder'
require './MarkovResponder'
require './Dictionary'
require './Emotion'
require '../Mecab.rb'

class Unmo
	def initialize(name)
		@name = name

		@mecab = Mecab.new

		@dictionary = Dictionary.new
		#		p @dictionary.random
		#		p @dictionary.pattern
		@emotion = Emotion.new(@dictionary)

		@resp_what = WhatResponder.new('What', @dictionary)
		@resp_random = RandomResponder.new('Random', @dictionary)
		@resp_pattern = PatternResponder.new('Pattern', @dictionary)
		@resp_template = TemplateResponder.new('Template', @dictionary)
		@resp_markov = MarkovResponder.new('Markov', @dictionary)
		@responder = @resp_random
	end

	def dialogue(input)
		@emotion.update(input)
		parts = @mecab.wakati2(input)
		case rand(100)
		when 0..29
			@responder = @resp_pattern
		when 30..49
			@responder = @resp_template
		when 50..69
			@responder = @resp_random
		when 70..89
			@responder = @resp_markov
		else
			@responder = @resp_what
		end
		#		@responder = rand(2) == 0 ? @resp_what : @resp_random;
		resp = @responder.response(input, parts, @emotion.mood)

		@dictionary.study(input, parts)
		return resp
	end

	def save
		@dictionary.save
	end

	def responder_name
		return @responder.name
	end

	def mood
		return @emotion.mood
	end

	#	def name 
	#		return @name
	#	end
	attr_reader :name

	def prompt
		return name + '(mood:' + @emotion.mood.to_s + "):" + responder_name + '>'
	end
end

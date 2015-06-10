require './Responder'

class RandomResponder < Responder
	# def initialize(name)
	# 	super
	# 	@phrases = []
	# 	#@responses = ["今日はさむいね", "チョコたべたい", "きのう10円ひろった"]
	# 	File.open("./dic/random.txt") do |f|
	# 		while line = f.gets
	# 			@phrases.push(line)
	# 		end
	# 	end
	# end

	def response(input, parts, mood)
		# return select_random(@phrases)
		return select_random(@dictionary.random)
	end


end
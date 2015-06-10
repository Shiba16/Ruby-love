require './Responder'

class MarkovResponder < Responder
	def response(input, parts, mood)
		keyword = ""
		parts.each do |word|
			if (word[0] !~ /^(\.|\,|\!|\?|\[\０\-\９\]|\！|\？)+$/ && word[1] == "名詞")
				keyword = word[0]
				break
			end
		end

		resp = @dictionary.markov.generate(keyword)
		return resp unless resp.nil?

		return select_random(@dictionary.random)
	end

end
require './Responder'

class TemplateResponder < Responder
	def response(input, parts, mood)
		keywords = []
		parts.each do |word|
			keywords.push(word[0]) if (word[1] == "名詞" && word[0] !~ /^(\.|\,|\!|\?|\[\０\-\９\]|\！|\？)+$/)
		end
		count = keywords.size
		if count > 0 and templates = @dictionary.template[count]
			template = select_random(templates)
			return template.gsub(/%noun%/){keywords.shift}
		end
		return select_random(@dictionary.random)
	end
end
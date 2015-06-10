require './Responder'

class PatternResponder < Responder
	def response(input, parts, mood) #本と違ってハッシュで書いた   #response が　reponse になって詰まる事件が発生した一時間は悩んだ
			#return @dictionary.pattern.has_key?(input) ? select_random(@dictionary.pattern[input].split('|')) : select_random(@dictionary.random) ←完全一致ならこの一文で書けた
			#こっちは部分一致版
#		@dictionary.pattern.each do |ptn_key, ptn_value|
#			if m = input.match(ptn_key)
#				resp = select_random(ptn_value.split('|'))
#				return resp.gsub(/%match%/, m.to_s)
#			end 
#		end
		@dictionary.pattern.each do |ptn_item|
			if m = ptn_item.match(input)        #入力が、トリガーとなる単語とマッチしていればmattisiteireba
#				p ptn_item
				resp = ptn_item.choice(mood)
				return resp.gsub(/%match%/, m.to_s)
			end
		end
		
		return select_random(@dictionary.random)
	end
end
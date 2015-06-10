class PatternItem
	SEPARATOR = /^((-?\d+)##)?(.*)$/

	def initialize(pattern, phrases) #ここでのphrasesは文字列. | による分割前のやつである. pattern も phrasesも文字列です
		SEPARATOR =~ pattern
			@modify, @pattern = $2.to_i, $3

		@phrases ={} #数字の重複への対処を考えねばならないのでちょい考えねばならない. 一つの必要感情値に対して、複数の回答選択肢がある可能性を考慮せねばならない
#		p @modify
		# @phrases  を　{1 => "aaaa|bbbbb|cccc", 2 =>"zzzzzzzzzzzzzz"} みたいにする
		# or {1 => ["aaaa", "bbbb", "cccd"], 2 =>["zzzzzzzzzzzzzzz"]}みたいにするか <- こっちを採用
		phrases.split('|').each do |phrase|
			if SEPARATOR =~ phrase
#				if ($2 != "" && $3 != "")
					if (@phrases.has_key?($2.to_i))
						#p @phrases[$2.to_i]
						#p $3
						@phrases[$2.to_i] = @phrases[$2.to_i].push($3)
						#p @phrases
						#@phrases.store($2.to_i, $3)
						
					else
						@phrases.store($2.to_i, [$3])
					end
#				end
			end
		end
	end



	def match(str)
		str = Regexp.escape(str)
		return str.match(Regexp.escape(@pattern))
	end

	def choice(mood)
		choices = [] #ここも、choicesを配列にするのかハッシュにするのかでバトルが始まる部分 <- choicesは配列にします
		@phrases.each do |need, ans| #ansは配列です
			choices.concat(ans) if suitable?(need,mood)
		end
#		p choices
		return (choices.empty?)? nil : select_random(choices)
	end


	def suitable?(need, mood)
		return true if need == 0
		if need > 0
			return mood > need #booleanを返している
		else
			return mood < need #booleanを返している
		end
	end

	def add_phrase(phrase)
		#p @phrases.has_value?(phrase)
		if !(@phrases.has_value?(phrase))
			if @phrases[0] != nil
				new_phrase = @phrases[0].push(phrase)
			else
				new_phrase = [phrase]
			end
			@phrases.store(0,new_phrase)
		end
	end

	def make_line
		line = @modify.to_s + "##" + @pattern + "\t"
		items = []

		@phrases.each do |need, phrases|
			items.push(phrases.uniq.map{|phrase| need.to_s + "##" + phrase})
		end
		line += items.join("|") 
		return line
	end
 


	attr_reader :modify, :pattern, :phrases
end 

#おそらく、クリア
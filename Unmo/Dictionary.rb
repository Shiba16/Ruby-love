require './PatternItem'
require './Markov'
class Dictionary
	def initialize
		load_random
		load_pattern
		load_template
		load_markov
	end

	def load_random
		@random = []

		begin
			File.open("./dic/random.txt") do |f|
				while line = f.gets
					@random.push(line)
				end
			end
		rescue => e
			puts(e.message)
			@random.push('こんにちは')
		end
	end

	def load_pattern
		@pattern = []
		begin
			File.open("./dic/pattern.txt") do |f|
				while line = f.gets
					pattern, phrases = line.chomp.split("\t")
					@pattern.push(PatternItem.new(pattern, phrases))
				end
			end
		rescue => e
			puts(e.message)
			@pattern.push("4##つくば	4##大学|9##市|2##みらい|2##エクスプレス|0##踊りなーがら羽ばたくたーめのステージではいーつーくばっていてーも|0##つくばねこ|0##ねこつくば|0##つくばたのしい|0##まつりつくば|0##まつりつくばに行きたい")
		end
	end

	def load_template
		@template = []
		begin
			File.open("./dic/template.txt") do |f|
				while line = f.gets
					count, template = line.split("\t")
					count = count.to_i
					@template[count] = [] unless @template[count]
					@template[count].push(template)
				end
			end
		rescue => e
			puts(e.message)
			@template.push("4	%noun%は%noun%%noun%の%noun%を見るか？")
		end
	end

	def load_markov
		@markov = Markov.new
		begin
			File.open("./dic/markov.dat", "rb") do |f|
				@markov.load(f)
			end
		rescue => e
			puts(e.message)
		end
	end


	def study(input, parts)
		study_random(input)
		study_pattern(input, parts)
		study_template(parts)
		study_markov(parts)
	end

	def study_random(input)
		if (!(@random.include?(input)))
			@random.push(input)
		end
	end

	def study_pattern(input, parts) #partsは、mecabクラスによって作られた多重配列
		parts.each do |word|
			i = 0
			checker = 0
			@pattern.each do |ptn_item|
				
				if (ptn_item.pattern == word[0] && word[1] == "名詞" && word[0] !~ /^(\.|\,|\!|\?|\[\０\-\９\]|\！|\？)+$/)
						checker = 1	
						break 
				else
					i += 1
				end
			end

			if (checker == 0 && word[1] == "名詞")
				@pattern.push(PatternItem.new(word[0], input))
			elsif checker == 1
				@pattern[i].add_phrase(input)
			end
		end
	end

	def study_template(parts)
		template = ''
		count = 0
		parts.each do |word|
			item = ""
			if (word[1] == "名詞" && word[0] !~ /^(\.|\,|\!|\?|\[\０\-\９\]|\！|\？)+$/)
				item = '%noun%'
				count += 1
			else
				item = word[0]
			end
			template += item
		end

		@template[count] = [] unless (@template[count] ||parts.size < 2)
		unless @template[count].include?(template)
			@template[count].push(template)
		end
		return unless count > 0
	end

	def study_markov(parts)
		@markov.add_sentence(parts)
	end

	def save
		File.open('./dic/random.txt', 'w') do |f|
			f.puts(@random.uniq)
		end

		File.open('./dic/pattern.txt', 'w') do |f|
			@pattern.each{|ptn_item| f.puts(ptn_item.make_line)}
		end

		File.open('./dic/template.txt', 'w') do |f|
			@template.each_with_index do |templates, i|
				templates && templates.uniq.each do |template|
					f.puts(i.to_s + "\t" + template) unless template == nil
				end
			end
		end

		File.open("./dic/markov.dat", "wb") do |f|
			@markov.save(f)
		end
	end

	attr_reader :random, :pattern, :template, :markov
end
# coding: utf-8
require '../Mecab.rb'
#require './utils'
#select_random はproto.rbで定義しているので、別ファイルに分割しないことにした

def select_random(ary)
	return ary[rand(ary.size)]
end

class Markov
	ENDMARK = '%END%'
	CHAIN_MAX = 30

	def initialize
		@dic = {}
		@starts = {}
	end

	def add_sentence(parts) #partsは配列、分かち書きしたやつ -> wakati2用に直す必要あり。
		return if parts.size < 3
		parts = parts.dup
		prefix1, prefix2 = (parts.shift)[0], (parts.shift)[0]
		add_start(prefix1)
		parts.each do |suffix|
			add_suffix(prefix1, prefix2, suffix[0])
			prefix1, prefix2 = prefix2, suffix[0]
		end
		add_suffix(prefix1, prefix2, ENDMARK)
	end

	def generate(keyword)
		return nil if @dic.empty?

		words = []
		prefix1 = (@dic[keyword])? keyword : select_start
		prefix2 = select_random(@dic[prefix1].keys)
		words.push(prefix1, prefix2)

		CHAIN_MAX.times do
			suffix = select_random(@dic[prefix1][prefix2])
			if suffix == ENDMARK
				break
			end
			words.push(suffix)
			prefix1, prefix2 = prefix2, suffix
		end
		return words.join
	end

	def load(f)
		@dic = Marshal::load(f)
		@starts =  Marshal::load(f)
	end

	def save(f)
		Marshal::dump(@dic, f)
		Marshal::dump(@starts, f)
	end

	private
	def add_suffix(prefix1, prefix2, suffix)
		@dic[prefix1] = {} unless @dic[prefix1]
		@dic[prefix1][prefix2] = [] unless @dic[prefix1][prefix2]
		@dic[prefix1][prefix2].push(suffix)
	end

	def add_start(prefix1)
		@starts[prefix1] = 0 unless @starts[prefix1]
		@starts[prefix1] += 1
	end

	def select_start
		return select_random(@starts.keys)
	end
end
#	private :add_suffix, :add_start, :select_start

# if $0 == __FILE__
# 	mecab = Mecab.new
# 	markov = Markov.new
# 	while line = gets
# 		texts = line.chomp.split(/[\.\。\?\？\!\！\	]+/)
# 		texts.each do |text|
# 			markov.add_sentence(mecab.wakati(text))
# 			print '.'
# 		end
# 	end
# 	print("complete\n")

# 	while line = STDIN.gets.chomp
# 		print('> ')
# 		break if line == ""
# 		parts = mecab.wakati(line)
# 		keyword, p = parts.find{|w, part| }
# 		puts(markov.generate(keyword))
# 	end
# end

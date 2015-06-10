#!/usr/bin/ruby


#result = system("ls -lh")
#print result
#print system("mecab")

#!/usr/bin/ruby
# begin
# #︎#exec("ls -lh")
# exec("mecab")
# #exec("こんにちは")
# rescue
# puts "error"
# end

# -*- encoding: UTF-8 -*-
require "open3"

def mecab(text)
	ret = []
	Open3.popen3("/usr/local/bin/mecab") do |stdin,stdout,stderr|
		stdin.puts text
		stdin.close
		stdout.each do |line|
			ret.push line
		end
	end
	ret.pop
	return ret
end

ret = mecab("今日はとても寒いです。")
ret.each do |line|
	print line
end

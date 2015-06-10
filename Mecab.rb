# coding: utf-8
require "open3"

class Mecab
  def wakati(text)
    ret = []
    Open3.popen3("/usr/local/bin/mecab -Owakati") do |stdin,stdout,stderr|
      stdin.puts text
      stdin.close
      stdout.each do |line|
        ret.concat(line.split("\s")) if line.split("\s")[1]!= nil
      end
    end
    return ret
  end

  def wakati2(text)
    ret = []
    Open3.popen3("/usr/local/bin/mecab") do |stdin,stdout,stderr|
      stdin.puts text
      stdin.close
      stdout.each do |line|
        ret.push([line.split("\s")[0], line.split("\s")[1].split(",")[0]]) if line.split("\s")[1]!= nil
      end
    end
    return ret
  end

end



##下はテスト用のやつ##

mecab = Mecab.new
#p mecab.wakati("今日はとても寒いでした。\nとてもつらい.EOS")
#p mecab.wakati2("今日はとても寒いでした。\nとてもつらい.EOS")

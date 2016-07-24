#!/usr/bin/env ruby
require 'nokogiri'

doc = File.open("the_most_common_chinese_characters.html") { |f| Nokogiri::HTML(f) }

doc.xpath('/html/body/blockquote/table/tr/td[2]').each do |path|
text = path.text
trad = text[/\(F(\S+?)[\),]/,1]
if(trad)
char=trad
else
char=text[/(\S+?)[\(,]?/,1]
end 
puts char
end
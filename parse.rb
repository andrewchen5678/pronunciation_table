#!/usr/bin/env ruby
require 'rest-client'
require 'csv'
require 'byebug'

def get_resp char
	begin
		response = RestClient.get 'https://en.wiktionary.org/w/index.php', {:params => {title: char, action: "raw"}}
		#if(response.code==200)
			str = response.body
		#else
		#	raise "error getting character from wiktionary"
	rescue RestClient::Exception => e
		puts "#{e.http_code}: char: #{char}"
	end

end


File.open('common_trad.txt', 'r:utf-8') do |f|
	CSV.open("converted_trad.csv", "w") do |csv|
		  csv << ["character", "mandarin", "cantonese"]
	f.each_char do |char|

		puts char
		


				do_redir = false
				begin 
					str=get_resp char
					
					
					if(str.include? '{{zh-pron')
						do_redir = false
					else
						redir = str[/{{zh-see\|(.+?)[|}]+?/,1]
						if(!redir.nil? && !redir.empty?)
							puts "redir char #{char} to #{redir}"
							char = redir.strip
							do_redir = true
						else
							do_redir = false
						end
					end
				end while do_redir

				mandarin = str[/{{zh-pron.*?^\|m\=(\S*?)\n/m,1]
				if(mandarin.nil?)
					mandarin = str[/{{cmn-hanzi\|.*?pin\=\[\[(\S*?)\]\]/,1]
				end

				cantonese = str[/{{zh-pron.*?^\|c\=(\S*?)\n/m,1]
			    if cantonese.nil?
					cantonese = str[/{{yue-hanzi\|.*?jyut\=(\S*?)\|/,1]
				end

		        csv << [char,mandarin,cantonese]

			end
		

	end
end


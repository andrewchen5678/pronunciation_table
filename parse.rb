#!/usr/bin/env ruby
require 'rest-client'

response = RestClient.get 'https://zh.wiktionary.org/w/index.php', {:params => {title: "国", action: "raw"}}
if(response.code==200)
puts response.body
end
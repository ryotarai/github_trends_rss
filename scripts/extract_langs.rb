require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'net/https'
require 'open-uri'
require 'pp'

doc = Nokogiri::HTML(open('https://github.com/trending'))

doc.css('a.select-menu-item-text.js-select-button-text.js-navigation-open').each do |a|
  url = a.attribute('href').value
  if url =~ /trending\?l=(.+)$/
    puts "'#{a.text}' => '#{$1}',"
  end
end



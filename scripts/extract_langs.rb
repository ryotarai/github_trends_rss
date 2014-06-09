require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'net/https'
require 'open-uri'
require 'pp'

doc = Nokogiri::HTML(open('https://github.com/trending'))
language_order = []
languages = {}

languages['all'] = 'All Languages'
languages['unknown'] = 'Unknown'

doc.css('a.select-menu-item-text.js-select-button-text.js-navigation-open').each do |a|
  url = a.attribute('href').value
  if url =~ /trending\?l=(.+)$/
    puts "#{$1}: #{a.text}"
    language_order << $1
    languages[$1] = a.text
  end
end

open(File.expand_path('../languages.rb', __FILE__), 'w') do |f|
  f.puts "LANGS = {"
  languages.each_pair do |key, name|
    f.puts "  '#{key}' => '#{name}',"
  end
  f.puts "}"
end

open(File.expand_path('../../public/js/languages.js', __FILE__), 'w') do |f|
  language_order.unshift('vim')
  language_order.unshift('bash')
  language_order.unshift('ruby')
  language_order.unshift('python')
  language_order.unshift('objective-c')
  language_order.unshift('javascript')
  language_order.unshift('go')
  language_order.unshift('c')
  language_order.unshift('unknown')
  language_order.unshift('all')

  f.puts 'langsOrder = ['
  f.puts language_order.map {|key| "'#{key}'" }.join(', ')
  f.puts '];'

  f.puts 'langs = {'
  languages.each_pair do |key, name|
    f.puts "  '#{key}': '#{name}',"
  end
  f.puts '};'
end


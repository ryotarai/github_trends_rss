require 'rubygems'
require 'bundler/setup'

require_relative './languages'
require 'nokogiri'
require 'rss'
require 'net/https'
require 'open-uri'
require 'pp'
require 'uri'

def github_trends_url(lang_key, since)
  lang = '' if lang == 'all'
  params = URI.encode_www_form({'l' => lang_key, 'since' => since})
  "https://github.com/trending?#{params}"
end

def rss_filename(lang_key, since)
  lang = lang_key.gsub('/', '_')
  "github_trends_#{lang_key}_#{since}.rss"
end

def fetch_repos(lang_key, since)
  url = github_trends_url(lang_key, since)
  retry_count = 0
  begin
    doc = Nokogiri::HTML(open(url))
  rescue OpenURI::HTTPError
    if retry_count < 3
      retry_count += 1
      sleep 30
      STDERR.puts "Retrying..."
      retry
    else
      STDERR.puts url
      raise
    end
  end
  doc.css('.repo-list li').map do |item|
    path = item.css('h3 a').attr('href').value
    _, owner, name = path.split('/')
    language = item.css('div.f6.text-gray.mt-2 > span.mr-3').text.strip

    {
      owner: owner,
      name: name,
      language: language,
      url: path,
      description: item.css('div.py-1 > p').text.strip,
    }
  end
end

def rss(lang_name, lang_key, since)
  repos = fetch_repos(lang_key, since)
  return '' if repos.empty?
  RSS::Maker.make("1.0") do |maker|
    caped_since = since.capitalize

    maker.channel.about = "http://github-trends.ryotarai.info/rss/#{rss_filename(lang_key, since)}"
    maker.channel.title = "GitHub Trends - #{lang_name} - #{caped_since}"
    maker.channel.description = "GitHub Trends - #{lang_name} - #{caped_since}"
    maker.channel.link = github_trends_url(lang_key, since)

    repos.each_with_index do |repo, index|
      item = maker.items.new_item
      item.link = "https://github.com#{repo[:url]}"
      item.title = "#{repo[:owner]}/#{repo[:name]} (##{index + 1} - #{lang_name} - #{caped_since})"
      item.description = "#{repo[:description]}\n(#{repo[:language]})"
      item.date = Time.now
    end
  end
end

%w! daily weekly monthly !.each do |since|
  LANGS.each_pair do |lang_key, lang_name|
    puts "crawling #{since} #{lang_name}..."
    path = File.expand_path("../../public/rss/#{rss_filename(lang_key, since)}", __FILE__)
    open(path, 'w') do |f|
      f.write rss(lang_name, lang_key, since).to_s
    end
    puts "done."
  end
end

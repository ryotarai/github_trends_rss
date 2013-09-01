require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'rss'
require 'net/https'
require 'open-uri'
require 'pp'

def github_trends_url(lang, since)
  lang = '' if lang == 'all'
  "https://github.com/trending?l=#{lang}&since=#{since}"
end

def rss_filename(lang, since)
  "github_trends_#{lang}_#{since}.rss"
end

def fetch_repos(lang, since)
  doc = Nokogiri::HTML(open(github_trends_url(lang, since)))
  doc.css('.repo-leaderboard-list-item').map do |item|
    {
      owner: item.css('a.repository-name .owner-name').text,
      name: item.css('a.repository-name strong').text,
      language: item.css('span.title-meta').text,
      url: item.css('a.repository-name').attribute('href').value,
      description: item.css('p.repo-leaderboard-description').text,
    }
  end
end

def rss(lang, since)
  repos = fetch_repos(lang, since)
  RSS::Maker.make("1.0") do |maker|
    caped_lang = lang.capitalize
    caped_since = since.capitalize

    maker.channel.about = "http://github-trends.ryotarai.info/rss/#{rss_filename(lang, since)}"
    maker.channel.title = "GitHub Trends - #{caped_lang} - #{caped_since}"
    maker.channel.description = "GitHub Trends - #{caped_lang} - #{caped_since}"
    maker.channel.link = github_trends_url(lang, since)

    repos.each_with_index do |repo, index|
      item = maker.items.new_item
      item.link = "https://github.com#{repo[:url]}"
      item.title = "#{repo[:owner]}/#{repo[:name]} (##{index + 1} - #{caped_lang} - #{caped_since})"
      item.description = repo[:description]
      item.date = Time.now
    end
  end
end

%w! daily weekly monthly !.each do |since|
  %w! unknown c javascript objective-c python ruby bash vim all !.each do |lang|
    puts "crawling #{since} #{lang}..."
    path = File.expand_path("../../public/rss/#{rss_filename(lang, since)}", __FILE__)
    open(path, 'w') do |f|
      f.write rss(lang, since).to_s
    end
    puts "done."
  end
end




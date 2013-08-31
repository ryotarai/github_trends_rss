require_relative '../config/environment'
require 'nokogiri'
require 'rss'
require 'net/https'
require 'open-uri'
require 'pp'

def fetch_repos(lang, since)
  doc = Nokogiri::HTML(open("https://github.com/trending?l=#{lang}&since=#{since}"))
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
    maker.channel.about = "http://example.com/index.rdf"
    maker.channel.title = "GitHub Trends - #{lang} - #{since}"
    maker.channel.description = "GitHub Trends - #{lang} - #{since}"
    maker.channel.link = "http://github.com/"

    repos.each_with_index do |repo, index|
      item = maker.items.new_item
      item.link = "https://github.com#{repo[:url]}"
      item.title = "##{index + 1} #{repo[:owner]}/#{repo[:name]} (#{lang}, #{since})"
      item.description = repo[:description]
      item.date = Time.now
    end
  end
end

%w! daily weekly monthly !.each do |since|
  (%w! unknown c javascript objective-c python ruby bash vim ! << '').each do |lang|
    puts since, lang
    path = Rails.root.join('public', 'rss', "github_trends_#{lang}_#{since}.rss")
    open(path, 'w') do |f|
      f.write rss(lang, since).to_s
    end
    puts "done."
  end
end




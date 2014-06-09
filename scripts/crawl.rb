require 'rubygems'
require 'bundler/setup'

require 'nokogiri'
require 'rss'
require 'net/https'
require 'open-uri'
require 'pp'
require 'uri'

LANGS = {
  'All Languages' => 'all',
  'Unknown' => 'unknown',
  'ABAP' => 'abap',
  'ActionScript' => 'as3',
  'Ada' => 'ada',
  'Apex' => 'apex',
  'AppleScript' => 'applescript',
  'Arc' => 'arc',
  'Arduino' => 'arduino',
  'ASP' => 'aspx-vb',
  'Assembly' => 'nasm',
  'Augeas' => 'augeas',
  'AutoHotkey' => 'autohotkey',
  'Awk' => 'awk',
  'Boo' => 'boo',
  'Bro' => 'bro',
  'C' => 'c',
  'C#' => 'csharp',
  'C++' => 'cpp',
  'Ceylon' => 'ceylon',
  'CLIPS' => 'clips',
  'Clojure' => 'clojure',
  'CoffeeScript' => 'coffeescript',
  'ColdFusion' => 'cfm',
  'Common Lisp' => 'common-lisp',
  'Coq' => 'coq',
  'CSS' => 'css',
  'D' => 'd',
  'Dart' => 'dart',
  'DCPU-16 ASM' => 'dcpu-16-asm',
  'Delphi' => 'delphi',
  'DOT' => 'dot',
  'Dylan' => 'dylan',
  'eC' => 'ec',
  'Ecl' => 'ecl',
  'Eiffel' => 'eiffel',
  'Elixir' => 'elixir',
  'Emacs Lisp' => 'emacs-lisp',
  'Erlang' => 'erlang',
  'F#' => 'fsharp',
  'Factor' => 'factor',
  'Fancy' => 'fancy',
  'Fantom' => 'fantom',
  'Forth' => 'forth',
  'FORTRAN' => 'fortran',
  'Go' => 'go',
  'Gosu' => 'gosu',
  'Groovy' => 'groovy',
  'Haskell' => 'haskell',
  'Haxe' => 'haxe',
  'Io' => 'io',
  'Ioke' => 'ioke',
  'Java' => 'java',
  'JavaScript' => 'javascript',
  'Julia' => 'julia',
  'Kotlin' => 'kotlin',
  'Lasso' => 'lasso',
  'LiveScript' => 'livescript',
  'Logos' => 'logos',
  'Logtalk' => 'logtalk',
  'Lua' => 'lua',
  'M' => 'm',
  'Matlab' => 'matlab',
  'Max' => 'max%2Fmsp',
  'Mirah' => 'ruby',
  'Monkey' => 'monkey',
  'MoonScript' => 'moonscript',
  'Nemerle' => 'nemerle',
  'Nimrod' => 'nimrod',
  'Nu' => 'nu',
  'Objective-C' => 'objective-c',
  'Objective-J' => 'objective-j',
  'OCaml' => 'ocaml',
  'Omgrofl' => 'omgrofl',
  'ooc' => 'ooc',
  'Opa' => 'opa',
  'OpenEdge ABL' => 'openedge-abl',
  'Parrot' => 'parrot',
  'Perl' => 'perl',
  'PHP' => 'php',
  'Pike' => 'pike',
  'PogoScript' => 'pogoscript',
  'PowerShell' => 'powershell',
  'Processing' => 'processing',
  'Prolog' => 'prolog',
  'Puppet' => 'puppet',
  'Pure Data' => 'pure-data',
  'Python' => 'python',
  'R' => 'r',
  'Racket' => 'racket',
  'Ragel in Ruby Host' => 'ragel-in-ruby-host',
  'Rebol' => 'rebol',
  'Rouge' => 'rouge',
  'Ruby' => 'ruby',
  'Rust' => 'rust',
  'Scala' => 'scala',
  'Scheme' => 'scheme',
  'Scilab' => 'scilab',
  'Self' => 'self',
  'Shell' => 'bash',
  'Slash' => 'slash',
  'Smalltalk' => 'smalltalk',
  'Standard ML' => 'standard-ml',
  'SuperCollider' => 'supercollider',
  'Swift' => 'swift',
  'Tcl' => 'tcl',
  'Turing' => 'turing',
  'TXL' => 'txl',
  'TypeScript' => 'typescript',
  'Vala' => 'vala',
  'Verilog' => 'verilog',
  'VHDL' => 'vhdl',
  'VimL' => 'vim',
  'Visual Basic' => 'visual-basic',
  'wisp' => 'wisp',
  'XC' => 'xc',
  'XML' => 'xml',
  'XProc' => 'xproc',
  'XQuery' => 'xquery',
  'XSLT' => 'xslt',
  'Xtend' => 'xtend',
}

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
  doc = Nokogiri::HTML(open(github_trends_url(lang_key, since)))
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
  LANGS.each_pair do |lang_name, lang_key|
    puts "crawling #{since} #{lang_name}..."
    path = File.expand_path("../../public/rss/#{rss_filename(lang_key, since)}", __FILE__)
    open(path, 'w') do |f|
      f.write rss(lang_name, lang_key, since).to_s
    end
    puts "done."
  end
end




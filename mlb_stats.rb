require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
  url = "https://www.baseball-reference.com/leagues/MLB/2019-standard-pitching.shtml"
  doc = Nokogiri::HTML(HTTParty.get(url))
  
  doc.css('table.stats_table tr').each do |row|
    team_name = row.css('th.left a').text
    next if team_name.empty?
    
    wins = row.css("[data-stat = 'W']").text
    losses = row.css("[data-stat = 'L']").text
    
    team = {
      team_name: team_name,
      wins: wins,
      losses: losses
    }
    puts team
  end
end

scraper
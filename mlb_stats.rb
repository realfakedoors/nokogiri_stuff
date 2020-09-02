require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
  url = "https://www.baseball-reference.com/leagues/MLB/2019-standard-pitching.shtml"
  doc = Nokogiri::HTML(HTTParty.get(url))
  teams = []
  
  doc.css('table.stats_table tr').each do |row|
    team_name = row.css('th.left a').text
    next if team_name.empty?
    
    wins = row.css("[data-stat = 'W']").text
    losses = row.css("[data-stat = 'L']").text
    era = row.css("[data-stat = 'earned_run_avg']").text
    hits_allowed = row.css("[data-stat = 'H']").text
    homers_allowed = row.css("[data-stat = 'HR']").text
    
    team = {
      team_name: team_name,
      wins: wins,
      losses: losses,
      era: era,
      hits_allowed: hits_allowed,
      homers_allowed: homers_allowed
    }
    teams << team
  end
  byebug
end

scraper
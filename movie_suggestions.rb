require 'nokogiri'
require 'httparty'

def intro
  puts "Looking for something to watch tonight?"
  puts "We've got you covered, with Certified Fresh picks from Rotten Tomatoes!"
  puts "Enter '1' for movies currently in theaters,"
  puts "'2' for movies on HBO Go, Netflix and Amazon Prime,"
  puts "'3' for TV shows,"
  puts "or 'exit' to exit the program."
end

def user_interface
  in_theaters = "https://www.rottentomatoes.com/browse/cf-in-theaters/"
  streaming = "https://www.rottentomatoes.com/browse/cf-dvd-streaming-all?services=hbo_go;netflix_iw;amazon_prime"
  tv = "https://www.rottentomatoes.com/browse/tv-list-3"

  loop do
    input = gets.chomp
    break if input == "exit"
    
    case input
    when '1'
      grab_listings(in_theaters)
    when '2'
      grab_listings(streaming)
    when '3'
      grab_listings(tv)
    else
      puts 'Uhh, try again!'
    end
  end
end

Film = Struct.new(:title, :tmeter)

def grab_listings(url)
  page = Nokogiri::HTML(HTTParty.get(url))
  films = []
  
  page.css('div.innerSubnav > table > tr').each do |film|
    title = film.css('td.middle_col > a').text
    tmeter = film.css('span.tMeterScore').text
    new_film = Film.new(title, tmeter)
    films << new_film
  end
  print_listings(films)
end

def print_listings(films)
  films.each do |film|
    puts "#{film.title} : #{film.tmeter}"
  end
end

intro
user_interface
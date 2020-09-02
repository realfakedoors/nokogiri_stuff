require 'nokogiri'
require 'httparty'

def grab_years
  url = "https://en.wikipedia.org/wiki/Academy_Award_for_Best_Picture"
  doc = Nokogiri::HTML(HTTParty.get(url))
  years = []
  
  doc.css('table.wikitable').each do |decade|
    film_counts_by_year = []
    current_row = 2
    this_decade = []
    
    # create a new 'year' object in this_decade for each year in the table.
    decade.css('tbody tr').each do |y|
      this_year = y.css("[style = 'text-align:center']")
      anno = this_year.text[0..3]
      next if anno == ""
      
      film_counts_by_year << this_year.attribute("rowspan").value.to_i - 1
      
      year = { year: anno }
      this_decade << year
    end
    
    # build film listings for each year, and promote the first listing to best picture.
    this_decade.each_with_index do |year, i|
      movie_count = film_counts_by_year[i]
      this_years_movies = []
      
      annual_film_data = decade.css('tbody tr')[current_row..current_row + movie_count].text.split("\n\n")
      annual_film_data.first[0] = ''
      annual_film_data.each_slice(2) do |f|
        film = { name: f.first, producer: f.last }
        this_years_movies << film
      end
      
      year[:best_picture] = this_years_movies[0]
      year[:nominees] = this_years_movies[1..-2]
      
      current_row += (movie_count + 1)
    end
    
    this_decade.each {|y| years << y }
  end
  years
end

def find_by_year
  data = grab_years
  
  puts " "
  puts "There are many sought-after honors in the film industry, but none as prestigious as Academy Award for Best Picture."
    
  loop do
    puts "Enter a year to view its Best Picture winner and nominees, or 'exit' to quit."
    requested_year = gets.chomp
    
    # handle the skip between 1932/33 and 1934:
    requested_year = '1934' if requested_year == '1933'
    
    break if requested_year == 'exit'
    
    puts (data.detect {|year| year[:year] == requested_year }) || "Sorry, we were unable to find any data for that year."
  end
end

find_by_year
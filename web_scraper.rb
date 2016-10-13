require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

#requesting the page we're scraping
page = HTTParty.get('http://berlinstartupjobs.com/', :headers => {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"})
#transforming the http request into a nokogiri object
parse_page = Nokogiri::HTML(page)
#empty array where we will store the craigslist jobs
jobs_array = []

parse_page.css('.w-section').css('.companies-container').css('.tag-link').map do |a|
  post_name = a.text
  jobs_array.push(post_name)
end

jobs_array = jobs_array.map! do |job|
  j = job.scan(/(.+)\((\d+)\)/).flatten
  [j[0], j[1].to_i]
end

jobs_array << ["Liefery ", 3]
jobs_array << ["Liefery ", 5]

#from array to hash
jobs_hash = Hash[jobs_array]
#group these companies, each in a hash ¿(object)?
jobs_hash = jobs_hash.map {|k,v| {label: k, values: [[v]]}}

#
# add new element from gathering data to end of value array
# jobs_hash.insert(-1, 'v') ?



#Pry.start(binding)

#push array into CSV files
#CSV.open('jobs.csv', 'w') do |csv|
#  csv << jobs_hash
#end

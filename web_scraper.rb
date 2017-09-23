require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'sinatra'
require 'byebug'

get '/' do
  time = Time.new

  page = HTTParty.get('http://berlinstartupjobs.com/', :headers => {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"})

  parse_page = Nokogiri::HTML(page)

  jobs_array = []

  parse_page.css('.w-section').css('.companies-container').css('.tag-link').map do |a|
    post_name = a.text
    jobs_array.push(post_name)
  end

  jobs_array = jobs_array.map! do |job|
    j = job.scan(/(.+)\((\d+)\)/).flatten
    [j[0], j[1].to_i]
  end

  file = File.read('companies.json')
  data_hash = JSON.parse(file)

  data_hash = data_hash.map do |k|
    k = JSON.parse(k)
    [k["label"], k["values"]] #if empty, skips, otherwise match
  end

  data_hash = Hash[data_hash] #hash needed to work with both hashes

  jobs_array.each do |k,v|
    data_hash[k] = data_hash.fetch(k,[]) + [v]
  end

  data_hash = data_hash.map {|k,v| {label: k, values: v}}

  companies_json = []

  data_hash.each do |hash|
    companies_json << hash.to_json
  end

  File.open('companies.json', 'w') do |f|
    f << companies_json
  end

  e = companies_json.map {|e| JSON.parse(e)}
  result = {"companies" => e}.to_json

  @page = HTTParty.put('https://api.myjson.com/bins/33750',
    :body => result,
    :headers => {'Content-Type' => 'application/json; charset=utf-8'})

  # puts result.inspect

  erb :shows
end

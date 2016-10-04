require 'net/http'
require 'uri'

#import = require
# = in python are : in ruby // headers={} headers:
uri = URI('http://berlinstartupjobs.com/') #URI takes just one url
req = Net::HTTP::Get.new(uri) #get in URI
req['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36' #use this header

res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req)} # URI documentation

puts res.code #status code

puts res.body

puts res.body.scan('<a href="http://berlinstartupjobs.com/companies/') #scan in the body of the document files that match a href=...

puts res.body.scan(/<a href="http:\/\/berlinstartupjobs\.com\/companies\/[^\s]+ class="tag-link">(.*)<\/a>/) #scan

companies = res.body.scan(/<a href="http:\/\/berlinstartupjobs\.com\/companies\/[^\s]+ class="tag-link">(.*)<\/a>/)

#companies.each do |company|
#  puts company[0].scan(/(.+)(\(\d+\))/) # scan in company array the first element company[0].scan
#end

#companies.each do |company|
#  puts company[0].scan(/(.+)\((\d+)\)/).inspect # = to .map
#end


companies = companies.map do |company|
  c = company[0].scan(/(.+)\((\d+)\)/).flatten
  [c[0], c[1].to_i]
end # do ... end = { }

  puts companies

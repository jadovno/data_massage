#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# get the latitude & longitude for all the places

require 'net/http'
require 'uri'
require 'viljushka'
require 'mongoid'
require 'nokogiri'
require 'cgi'

# plan:
# get the place name from the DB
# search for it on wikipedia
#
##### conversion of seconds to decimal for
##### latitude & longitude
#
# h / 1
# m / 60
# s / 3600
# val = h + m + s



# скида страницу са Википедије
# и враћа резултат
#
def get_page(name)

  sr = "http://sr.wikipedia.org/wiki/"
  if name =~ /#{sr}/
    requested_url = name
  else
    name.gsub!(/\ /, "_")
    requested_url = sr + (CGI::escape name)
  end

  url = URI.parse(requested_url)
  request = Net::HTTP::Get.new(url.path)

  response = Net::HTTP.start(url.host, url.port) { |http|
    http.request(request)
  }

  if response.code =~ /301/
    get_page(response.header['location'])
  else
    return response.body
  end

end


# претвара координате из секунде у децималне
#
def seconds_to_decimal(lat_long)
  # puts "DBG: seconds_to_decimal - value given: #{lat_long}."
  lat, long = lat_long.split ','
  lat, long = lat_long.split(' ') if lat.nil? or long.nil?

  raise "Не важећи координати, раздвајање је покушато на запету и на размак..."\
  if lat.nil? or long.nil?

  latitude = get_decimal(lat)
  longitude = get_decimal(long)
  return latitude, longitude
end

def get_decimal(val)
  val.gsub!(/[^\d]/, '')
  h, m, s = val.scan(/.{1,2}/m)

  # игноришем секунде зато што може и без њих
  puts "Не важећи координати " if h.nil? or m.nil?

  result = h.to_i + ((m.to_f / 60) + (s.to_f / 3600))
end

def print_coords(arr)
  puts "Latitude: #{roundit arr[0]}"
  puts "Longitude: #{roundit arr[1]}"
end

def roundit(num)
  num.to_f.round 4
end

def insert_lat_long(mesto, lat_long)
  # victims = Victim.all(conditions: {grad: mesto})
  # victims = Victim.all(conditions: { "location": mesto})
  victims = Victim.where(grad: mesto)
  # victims = Victim.where(location: mesto)
  lat = lat_long[0].to_f.round(4)
  long = lat_long[1].to_f.round(4)
  puts "lat: #{lat} long: #{long}"
  puts "victims in #{mesto}: #{victims.count}"
  victims.each do |v|
    # puts "victim: #{v.ime}"
    puts "victim: #{v.puno_ime}"
    v.update_attributes(:latitude => lat,
                        :longitude => long)
    # puts "after #{v.ime} #{v.latitude} & #{v.longitude}"
    puts "after #{v.puno_ime} #{v.latitude} & #{v.longitude}"
  end
end

#### Get all the places
##########################

Mongoid.load!('./mongoid.yml', :development)

class Victim
  include Mongoid::Document
end

places = Victim.all.map(&:grad).uniq
# places = Victim.all.map(&:location).uniq

not_found = []

places.each do |mesto|
  puts "Место: #{mesto}"
  doc = Nokogiri::HTML.parse(get_page(mesto.po_gaju))
  lat_long = doc.xpath('//span[@id="coordinates"]/a[@class="external text"]').inner_text

  if lat_long.empty?
    lat = doc.xpath('//span[@class="geo-default"]/*/span[@class="latitude"]').inner_text
    long = doc.xpath('//span[@class="geo-default"]/*/span[@class="longitude"]').inner_text

    if (lat.empty?) or (long.empty?)
      puts "не могу да нађем координате!"
      not_found << mesto
    else
      print_coords(seconds_to_decimal lat + "," + long)
      insert_lat_long(mesto, (seconds_to_decimal lat + "," + long))
    end
  else
    print_coords(seconds_to_decimal lat_long)
    insert_lat_long(mesto, (seconds_to_decimal lat_long))
  end
  puts "################################"
end

puts "Места за која нисам могао да нађем координате:"
puts " #{not_found}"
puts "Укупан број: #{not_found.count}"

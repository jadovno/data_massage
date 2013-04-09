# -*- coding: utf-8 -*-
require 'mongoid'

def setup
  Mongoid.load!('./mongoid.yml', :development)
end

class Victim
  include Mongoid::Document
end

desc "count of victims"
task :victims do
  setup
  puts Victim.count
end

desc "rename 'BanjaLuka' to 'Banja Luka'"
task :rename_bl do
  setup
  Victim.where(grad: 'BanjaLuka').each do |v|
    puts "##########################"
    puts "before -> victim: #{v.grad}"
    v.update_attributes(grad: "Banja Luka")
    puts "after -> victim: #{v.grad}"
    puts "##########################"
  end
end

desc "remove non numeric values from age column"
task :clean_age do
  setup
  # remove ' g., g, godina' from 'starost' column
  Victim.where(starost: /(\ ?g\.?|godina)/).each do |v|
    v.update_attributes(starost: "#{v.starost.gsub(/(\ ?g\.?|godina)/, '')}")
  end
end

desc "remove HTML from the db dump"
task :strip_html, :file do |t, args|
  # puts "Args were: #{args[:file]}"
  file = File.open("#{args[:file]}", "rb")
  contents = file.read
  contents.gsub!(/<[^>]*>/, '')
  contents.gsub!(/\\"/, "'")
  File.open("dumps/new_file", "w") {|f| f.write(contents) }
end

desc "import dump into MongoDB"
task :import do
  file = "dumps/new_file"
  sh "mongoimport --host localhost --db jadovno --collection victims --type csv --file #{new_file} --headerline"
end

desc "export Jadovno DB"
task :export do
  export_file = "dumps/export.json"
  sh "mongoexport -h localhost:27017 -d jadovno -c victims -o #{export_file}"
end

desc "add sex"
task :add_sex do
  setup
  def assign_sex(nationality, sex)
    Victim.where(nacionalnost: nationality).each do |v|
      v.update_attributes(sex: sex)
    end
  end

  ["Jevrejin", "Srbin", "Hrvat", "Rom", "Musliman", "Slovenac", "Mađar",
  "Crnogorac", "Rus", "Čeh, rođen u Čehoslovačkoj"].each do |nationality|
    assign_sex(nationality, "m")
  end

  ["Jevrejka", "Hrvatica", "Slovenka", "Srpkinja"].each do |nationality|
    assign_sex(nationality, "f")
  end

  # for unknown, leave blank
  assign_sex("", "")
end

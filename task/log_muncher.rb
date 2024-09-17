include Gem::Text
require 'csv'

file_data = File.read("data/log.txt").split("\n").map { |x| x[/(=> )(.*)/, 2] }
#hash_file_data = file_data.to_h { |line| [line, file_data.count(line)] }
hash_file_data = Hash.new(0)
file_data.each do |line|
  hash_file_data[line] += 1
end
hash_real_data = hash_file_data.sort_by{ |name, votes| -votes }.first(200).to_h

puts 2
#CSV.open("votes_data.csv", "wb", encoding: 'UTF-8') {|csv| hash_real_data.to_a.each {|elem| csv << elem} }
#puts 'temp'

result_data = Hash.new(0)
hash_real_data.each do |name, votes|
  hash_file_data.each do |mistaken_name, votes2|
    if levenshtein_distance(name, mistaken_name) <= 4
      result_data[name] += hash_file_data.delete(mistaken_name)
    end
  end
end

puts 1

CSV.open("votes_data.csv", "wb", encoding: 'UTF-8') {|csv| result_data.to_a.each {|elem| csv << elem} }

puts 0

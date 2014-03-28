require 'csv'

class ClosestId 
  attr_reader :lat_hash, :long_hash, :closer_hash, :user_lat, :user_long

  def initialize
    @lat_hash = Hash.new([])
    @long_hash = Hash.new([])
    @closer_hash = {}
  end

  def perform
    parse_csv
    get_closest(get_user_input)
  end

  def get_user_input
    print "Enter Latitude and longitude in the format 33,24 "
    user_input = gets.chomp.split(',')
    @user_lat,@user_long = user_input.map(&:to_i)
  end

  def get_closest(args)
    i_lat = args[0]
    i_long = args[1]

    0.upto(4) do |i|
      populate_closer_hash_with_lat(i_lat.floor + i)
      populate_closer_hash_with_long(i_long.floor + i)
    end

    1.upto(5) do |i|
      populate_closer_hash_with_lat(i_lat.floor - i)
      populate_closer_hash_with_long(i_long.floor - i)
    end

    final_double_array = @closer_hash.sort_by{|k,v| v}
    puts "The 10 closest item_ids are "

    0.upto(9) do |i|
      print "#{final_double_array[i][0]} "
    end
  end

  def populate_closer_hash_with_lat(passed_lat)
    get_lat_array = lat_hash[passed_lat]
    get_lat_array.each do |loc|
      @closer_hash[loc[0]] = distance(loc[1].to_i,loc[2].to_i)
    end
  end

  def populate_closer_hash_with_long(passed_long)
    get_long_array = long_hash[passed_long]
    get_long_array.each do |long|
      @closer_hash[long[0]] = distance(long[1].to_i,long[2].to_i)
    end
  end



  def parse_csv
    contents = CSV.open "item_locations.csv", headers: true, header_converters: :symbol

    contents.each do |row|
      @lat_hash[row[:latitude].to_i.floor] += [[row[:id],row[:latitude],row[:longitude]]]
      @long_hash[row[:longitude].to_i.floor] += [[row[:id],row[:latitude],row[:longitude]]]
    end
  end

  def distance(lat, long)
    Math.sqrt((lat-user_lat)**2 + (long-user_long)**2)
  end 
end


closest = ClosestId.new.perform

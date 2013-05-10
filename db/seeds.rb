require 'randexp'
require 'rubygems'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Requiring seeds"
#require the seeds
Dir["#{Rails.root}/db/seeds/*.rb"].each { |file| require file }

# Don't log stuff!
#Mongoid.logger = nil
#Paperclip.options[:log] = false

# Clear everything.
#if !Rails.env.production?
  #puts "Wiping database collections"

  ##Mongoid 2 way...
  ##Mongoid.master.collections.reject { |c| c.name =~ /^system./}.each(&:drop)

  ## Monoid 3 way?
  ##session = Moped::Session.new(Mongoid.sessions['default']['hosts'])
  ##session.use Mongoid.sessions['default']['database']
  #Mongoid::Sessions.default.drop
#else
  #puts "Woahhhh there cowboy! You're trying to remove all the collections on production?!"
#end

def time_block
  start_time = Time.now
  yield
  puts " - Time: #{Time.now - start_time}"
end

# Link us for testing goodness!
#time_block { seed_users }
time_block { seed_locations }

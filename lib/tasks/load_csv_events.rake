require 'csv'

namespace :admin do
  desc "Populate venues with CSV data from Songkick and Google"
  task :load_csv_venues => :environment do
    count = 0
    CSV.foreach('data/events.csv', headers: true) do |row|
      break if count > 1000
      count += 1
      venue = row.to_hash
      v = {
        name: venue['name'],
        min_price: venue['price_level'],
        max_price: venue['price_level'],
        city: venue['city'],
        address: venue['address'],
        url: venue['url'],
        image_file_name: venue['places_photo_url']
      }
      Venue.create(v)
    end
  end
end

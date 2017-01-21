# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

comedians = [{ 
  name: 'Jimmy Carr', 
  mugshot_url: 'http://i3.liverpoolecho.co.uk/incoming/article10173821.ece/ALTERNATES/s615/JS73497203.jpg'
}, { 
  name: 'Ed Byrne', 
  mugshot_url: 'https://metrouk2.files.wordpress.com/2009/11/ed_byrneg_450x300.jpg' 
}, { 
  name: "Dara O'Briain", 
  mugshot_url: "http://i.telegraph.co.uk/multimedia/archive/01756/PD39077264_DTMP_H6_1756708c.jpg" 
}, { 
  name: 'Micky Flanagan', 
  mugshot_url: "http://static.guim.co.uk/sys-images/Arts/Arts_/Pictures/2013/10/20/1382281446969/Micky-Flanagan-010.jpg" 
}, { 
  name: 'Eddie Izzard', 
  mugshot_url: 'https://static.independent.co.uk/s3fs-public/styles/story_medium/public/thumbnails/image/2016/01/08/02/5911761.jpg'
}, { 
  name: 'Bill Burr', 
  mugshot_url: 'http://speakerdata2.s3.amazonaws.com/photo/image/758589/Bill-Burr-40027.jpg' 
}, { 
  name: 'Jim Jefferies', 
  mugshot_url: "http://speakerdata2.s3.amazonaws.com/photo/image/848621/Jim-J-Gig-Guide-Head-Shot.jpg" 
}, { 
  name: 'Rhys Darby', 
  mugshot_url: "https://static.standard.co.uk/s3fs-public/thumbnails/image/2012/07/23/15/Rhys-Darby.jpg" 
}, { 
  name: 'Ross Noble', 
  mugshot_url: "http://i.dailymail.co.uk/i/pix/2010/09/29/article-1316310-0B2A315F000005DC-443_306x363.jpg" 
}, { 
  name: 'Sean Lock', 
  mugshot_url: "https://media.timeout.com/images/102273381/image.jpg" 
}, {
  name: "Greg Davies",
  mugshot_url: "http://res.cloudinary.com/uktv/image/upload/v1438008613/negq62si6a0c9gxyn1ac.jpg"
}, {
  name: 'Frankie Boyle',
  mugshot_url: "http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2011/11/25/1322220839370/Frankie-Boyle-007.jpg"
}]

comedians.each do |comedian|
  c = Comedian.find_or_initialize_by(name: comedian[:name])
  c.mugshot = URI.parse(comedian[:mugshot_url])
  c.save
end
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
  mugshot_url: 'http://images.gr-assets.com/authors/1240952053p5/12790.jpg'
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
  mugshot_url: "http://www.primeperformersagency.co.uk/uploads/images/speakers/greg-davies.jpg"
}, {
  name: 'Frankie Boyle',
  mugshot_url: "http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2011/11/25/1322220839370/Frankie-Boyle-007.jpg"
}, {
  name: "Jon Richardson",
  mugshot_url: "https://therealchrisparkle.files.wordpress.com/2014/05/jon-richardson.jpg"
}, {
  name: "Jason Manford",
  mugshot_url: "http://www.jasonmanford.com/jasonmanford/wp-content/themes/jasonmanford2014/images/JasonManford-Profile.png"
}, {
  name: "Lee Mack",
  mugshot_url: "http://i.dailymail.co.uk/i/pix/2012/06/07/article-2155382-137F844B000005DC-978_306x350.jpg"
}, {
  name: "Mark Watson",
  mugshot_url: "http://oxfordliteraryfestival.org/images/author/2078/mark-watson-001__main.gif"
}, {
  name: "Bill Bailey",
  mugshot_url: "https://i.digiguide.tv/p/0810/21927-BillBailey-12234724660.jpg"
}, {
  name: "Sarah Millican",
  mugshot_url: "http://www.gigglebeats.co.uk/wp-content/uploads/Millica-Custom.jpg"
}, {
  name: "Sara Pascoe",
  mugshot_url: "https://laughoutlondon.files.wordpress.com/2011/11/sara-pascoe-2007-september.jpg"
}, {
  name: 'Russell Howard',
  mugshot_url: "https://s-media-cache-ak0.pinimg.com/originals/f6/42/1a/f6421a8ba5b320f0f369c33df8142ee4.png"
}, {
  name: "Peter Kay",
  mugshot_url: "http://ichef-1.bbci.co.uk/news/660/cpsprodpb/11806/production/_86968617_peter_kay_bbc.jpg"
}, {
  name: "Omid Djalili",
  mugshot_url: "http://s452743659.websitehome.co.uk/wp-content/uploads/2013/01/Omid-Djalili.jpg"
}, {
  name: "Stewart Lee",
  mugshot_url: "https://laughoutlondon.files.wordpress.com/2014/07/stewart-lee-laugh-out-london.jpg"
}, {
  name: "Milton Jones",
  mugshot_url: "http://www.jestfest.ie/wp-content/uploads/2016/02/Milton-Jones-A.jpg"
}, {
  name: "Aisha Tyler",
  mugshot_url: 'http://celebinfoz.com/wp-content/uploads/2015/12/Aisha-Tyler-Favorite-Things-Height.jpg'
}, {
  name: "Reginald D Hunter",
  mugshot_url: 'http://d13rtmsmlweq99.cloudfront.net/cms_media/images/events/ac931fef846f2865cc2e33bdf21e01c3.1437576801.jpg'
}, {
  name: "Steve Hughes",
  mugshot_url: "http://dublinconcerts.ie/content/uploads/2013/10/steve-hughes.jpg"
}, {
  name: "Henning Wehn",
  mugshot_url: "http://assets2.livebrum.com/images/glee-club/blwy/home/henning-wehn-1350588456.jpg"
}, {
  name: 'Andy Zaltzman',
  mugshot_url: 'https://www.vivacity-peterborough.com/media/4041/25_andy_zaltman.jpg'
}, {
  name: "Rob Beckett",
  mugshot_url: "http://www.colstonhall.org/wp-content/uploads/2013/10/Rob-Beckett-High-Res-20131-e1381919189325-460x300.jpg"
}, {
  name: "Russell Brand",
  mugshot_url: "http://d279m997dpfwgl.cloudfront.net/wp/2014/10/russellbrand.jpg"
}]

comedians.each do |comedian|
  begin
    c = Comedian.find_or_initialize_by(name: comedian[:name])
    c.mugshot = URI.parse(comedian[:mugshot_url])
    c.save
  rescue Exception => e 
    ap "Oh no! #{e.message}"
  end
end
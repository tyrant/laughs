desc "Update every comedian's mugshot"
task create_comedians_and_mugshots: :environment do 

  comedians_info = [{ 
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
  }, {
    name: "Tom Allen",
    mugshot_url: "https://static1.squarespace.com/static/55b3e67ae4b06a14d457be75/t/56b8673120c6474278b42bf5/1454925680989/"
  }, {
    name: "Billy Connolly",
    mugshot_url: "https://www.thestar.com/content/dam/thestar/entertainment/2015/10/12/billy-connolly-giving-a-joyous-middle-finger-to-good-taste/billy-connolly.jpg"
  }, {
    name: 'Jack Whitehall',
    mugshot_url: "http://www.gigglebeats.co.uk/wp-content/uploads/94c8cb51-45f3-4f5f-bea2-719bed721e31_625x352.jpg"
  }, {
    name: 'Adam Hills',
    mugshot_url: "http://www.showbizmonkeys.com/phpthumb/phpThumb.php?src=../uploaded/adamhillsjpg_0734.jpg"
  }, {
    name: 'Andy Parsons',
    mugshot_url: 'http://www.justthetonic.com/artistimages/andy-parsons/gallery/andy-parsons_4.jpg'
  }, {
    name: 'Charlie Baker',
    mugshot_url: "https://www.comedy.co.uk/images/library/fringe/2015/250x250/charlie_baker.jpg"
  }, {
    name: 'Jeremy Hardy',
    mugshot_url: "http://jeremyhardy.co.uk/wp/wp-content/themes/thesis_184/custom/rotator/portraight.jpg"
  }, {
    name: 'Joel Dommett',
    mugshot_url: "http://media.ents24network.com/image/000/150/199/7e7ab661bf0b0f9653291b1fc6c3542819ce7bcd.jpg"
  }, {
    name: 'Mark Steel',
    mugshot_url: "https://stratfordobserver.co.uk/wp-content/uploads/2016/04/MarkSteel.jpg"
  }, {
    name: 'Phill Jupitus',
    mugshot_url: "http://connachttribune.ie/wp-content/uploads/2014/10/x4-Phill-Jupitus.jpg"
  }, {
    name: 'Rich Hall',
    mugshot_url: "http://www.northwestend.co.uk/images/Rich_Hall.jpg"
  }, {
    name: 'Russell Kane',
    mugshot_url: "https://therealchrisparkle.files.wordpress.com/2014/02/rk13_russell_kane.jpg"
  }, {
    name: 'Seann Walsh',
    mugshot_url: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2016/03/28/17/seann-walsh.jpg"
  }, {
    name: 'Shappi Khorsandi',
    mugshot_url: "http://www.beyondthejoke.co.uk/sites/default/files/_2014SHAPPIK_PV.jpg"
  }, {
    name: 'Suzi Ruffell',
    mugshot_url: "http://assets3.livebrum.com/images/glee-club/c01s/home/suzi-ruffell-patrick-monahan-gary-delaney-1376212749.jpg"
  }, {
    name: "Aisling Bea",
    mugshot_url: "https://s-media-cache-ak0.pinimg.com/originals/1d/4c/b1/1d4cb104a0833b87e7130e78d3fb4ef7.jpg"
  }, { 
    name: "Nina Conti",
    mugshot_url: "http://i.telegraph.co.uk/multimedia/archive/02642/NINA-CONTI_2642573b.jpg"
  }, {
    name: "Lucy Porter",
    mugshot_url: "https://s-media-cache-ak0.pinimg.com/originals/a8/5e/12/a85e120c4830d45c78bc50ca5976ab4d.jpg"
  }, {
    name: "Rory Bremner",
    mugshot_url: 'https://www.yorkmix.com/wp-content/uploads/2016/05/rory-bremner.jpg'
  }, {
    name: "Ken Dodd",
    mugshot_url: 'http://www.theartsdesk.com/sites/default/files/imagecache/mast_image_square/mastimages/3bc03dadbda2be3aa076f3f425c6498a.jpg',
  }, {
    name: "Brian Conley",
    mugshot_url: "http://www.celebrityradio.biz/wp-content/uploads/2014/09/Brian-Conley-Life-Story-Interview-2014.jpg"
  }, {
    name: "Joe Lycett",
    mugshot_url: "https://www.comedy.co.uk/images/library/fringe/2012/250x250/joe_lycett.jpg"
  }, {
    name: "Romesh Ranganathan",
    mugshot_url: "http://www.emerypr.com/wp-content/uploads/2014/03/romesh.jpg"
  }, {
    name: "Danny Baker",
    mugshot_url: "http://i.dailymail.co.uk/i/pix/2016/05/29/10/0227E51A00000514-3614905-Evans_has_asked_Danny_Baker_pictured_to_help_improve_the_script-a-6_1464514411170.jpg"
  }, {
    name: "Jethro",
    mugshot_url: "http://www.edp24.co.uk/polopoly_fs/1.38870.1264526104!/image/729764690.jpg_gen/derivatives/landscape_630/729764690.jpg"
  }, {
    name: 'Roy "Chubby" Brown',
    mugshot_url: "http://www.expressandstar.com/wpmvc/wp/wp-content/uploads/2011/12/Roy-Chubby-Brown.jpg"
  }, {
    name: "Jack Dee",
    mugshot_url: "http://www.eventim.co.uk/obj/media/UK-eventim/galery/222x222/j/jack-dee-tickets.jpg"
  }, {
    name: "Keith Farnan",
    mugshot_url: "http://www.getcomedy.com/blog/wp-content/uploads/2011/08/keithfarnanqanda.jpg"
  }, {
    name: "Max Boyce",
    mugshot_url: "http://assets1.livebrum.com/images/town-hall/b7b4/home/max-boyce.jpg"
  }, {
    name: "James Acaster",
    mugshot_url: "https://therealchrisparkle.files.wordpress.com/2015/10/james-acaster.jpg"
  }, {
    name: "Angelos Epithemiou",
    mugshot_url: "http://media.ents24network.com/image/000/033/681/0c5fb9419b4e0064c1fdbe51797dfc540ab2a085.jpg"
  }, {
    name: "Ruby Wax",
    mugshot_url: "http://i.dailymail.co.uk/i/pix/2013/05/29/article-0-19B5AC77000005DC-375_636x501.jpg"
  }, {
    name: "Jim Davidson",
    mugshot_url: "http://images.dailystar.co.uk/dynamic/47/photos/257000/620x/jiim_davidson-365086.jpg"
  }, {
    name: "John Bishop",
    mugshot_url: "http://cdn.images.dailystar.co.uk/dynamic/1/281x351/292344_1.jpg"
  }, { 
    name: "Jon Culshaw",
    mugshot_url: "https://upload.wikimedia.org/wikipedia/commons/e/ee/Jon_Culshaw.jpg"
  }, {
    name: "Joe Longthorne",
    mugshot_url: "https://pbs.twimg.com/profile_images/704065419787837441/hbG2pLBf.jpg"
  }, {
    name: "Ricky Gervais",
    mugshot_url: "https://metrouk2.files.wordpress.com/2012/09/article-1347880008797-150c24fa000005dc-711952_466x348.jpg"
  }, {
    name: "Lee Nelson",
    mugshot_url: "http://cdn.partyearth.com/photos/d96dbb70f52a799767f5f6b9e194c8b6/lee-nelson_s345x230.jpg?1375039490"
  }, {
    name: "Jasper Carrot",
    mugshot_url: "http://theatrebath.co.uk/wp-content/uploads/2015/04/Jasper-Carrott-photograph.jpg"
  }, {
    name: "Tom Stade",
    mugshot_url: "https://thecomedyclub.co.uk/comedian_images/_comedianProfile/Tom-Stade.jpg"
  }, {
    name: "Tim Key",
    mugshot_url: "http://blog.ticketmaster.co.uk/wp-content/uploads/2016/02/Tim-Key.jpg"
  }, {
    name: "John Shuttleworth",
    mugshot_url: 'https://pbs.twimg.com/profile_images/489098037550006273/_XcWKEg3.jpeg'
  }, {
    name: "Cannon And Ball",
    mugshot_url: "http://i1.mirror.co.uk/incoming/article6278804.ece/ALTERNATES/s615b/Tommy-Cannon-and-Bobby-Ball-in-Cannon-and-Ball--1980s.jpg"
  }, {
    name: "Bianca Del Rio",
    mugshot_url: "http://cdn.thedailybeast.com/content/dailybeast/articles/2015/12/08/bianca-del-rio-is-ready-for-her-comedy-close-up/jcr:content/image.crop.800.500.jpg/48318484.cached.jpg"
  }, {
    name: "Jerry Sadowitz",
    mugshot_url: "https://www.comedy.co.uk/images/library/people/300/j/jerry_sadowitz.jpg"
  }, {
    name: "Luisa Omielan",
    mugshot_url: "http://cuckooreview.com/wp-content/uploads/2014/06/luisaomielan.jpg"
  }, {
    name: "Des O'Connor",
    mugshot_url: "http://e9199c8ddf0363e43e46-ecfeac194f49b8692f3d8a97aad0f9b5.r13.cf3.rackcdn.com/53f47a186691a-des.l.m.jpg"
  }, {
    name: "Brian Cox",
    mugshot_url: "http://i1.manchestereveningnews.co.uk/incoming/article1208207.ece/ALTERNATES/s615/C_71_article_1597541_image_list_image_list_item_0_image.jpg"
  }, {
    name: "Limmy",
    mugshot_url: "http://media.ents24network.com/image/000/204/635/5b9175d3acc87b21abbee7bbd4131d6124ae9e65.jpg"
  }, {
    name: "Stewart Francis",
    mugshot_url: "https://shelleyhanveywriter.files.wordpress.com/2010/11/stewart-francis-tour-pictures-lst068944.jpg"
  }, {
    name: "Jimmy Jones",
    mugshot_url: "http://www.phoenixfm.com/wp-content/uploads/2014/06/f5ac3d2e7ed487a473fc5eaf8c8526a94154515e1.jpg"
  }, {
    name: "Nick Helm",
    mugshot_url: "http://comedycv.co.uk/nickhelm/nick-helm-2011-october.jpg"
  }, {
    name: "Miles Jupp",
    mugshot_url: "http://www.southwalesargus.co.uk/resources/images/5082871/"
  }, {
    name: "Doc Brown",
    mugshot_url: "http://i.telegraph.co.uk/multimedia/archive/01694/doc-brown_1694990c.jpg"
  }, {
    name: "Jamali Maddix",
    mugshot_url: "https://pbs.twimg.com/media/C0NLQ9YXAAAyiRe.jpg"
  }, {
    name: "Bridget Christie",
    mugshot_url: "https://static.standard.co.uk/s3fs-public/thumbnails/image/2015/09/04/15/bridget-christie-sep15.jpg"
  }, {
    name: "Joe Pasquale",
    mugshot_url: "http://www.ticketline.co.uk/images/artist/joe-pasquale/joe-pasquale.jpg"
  }, {
    name: "Billy Pearce",
    mugshot_url: "http://www.comedians.co.uk/images/profiles/?p=268&s=250"
  }, {
    name: "Basketmouth",
    mugshot_url: "http://stargist.com/wp-content/uploads/2013/08/BasketMouth.jpg"
  }, {
    name: "Tom Wrigglesworth",
    mugshot_url: "http://www.tomwrigglesworth.co.uk/img/photos/silver-sm.jpg"
  }, {
    name: "Al Murray",
    mugshot_url: "http://i.telegraph.co.uk/multimedia/archive/03095/almurray_3095151b.jpg"
  }, {
    name: "Jimmy Tarbuck",
    mugshot_url: "http://i.dailymail.co.uk/i/pix/2013/05/06/article-2320419-011A6FE200000578-227_306x423.jpg"
  }, {
    name: "Ardal O'Hanlon",
    mugshot_url: "http://resources2.atgtickets.com/static/28472_full.jpg"
  }, {
    name: "Paul Sinha",
    mugshot_url: "https://metrouk2.files.wordpress.com/2015/07/paul-sinha-headshot-300dpi_-edited-1-e1437906710155.jpg?w=748&h=455&crop=1"
  }, {
    name: "Count Arthur Strong",
    mugshot_url: "http://static.guim.co.uk/sys-images/Guardian/Pix/pictures/2014/12/22/1419254986023/Count-Arthur-Strong-012.jpg"
  }, {
    name: "Luke Kempner",
    mugshot_url: "https://files.list.co.uk/images/festivals/2016/fringe/2016LUKEKEM-PT-300.jpg"
  }, {
    name: "Simon Evans",
    mugshot_url: "http://www.high50.com/wp-content/uploads/2016/01/Simon-Evans.-Comedian.-Finance-at-50.-Money.-Press-pic.-620x520.jpg"
  }, {
    name: "Mike Doyle",
    mugshot_url: "http://media.ents24network.com/image/000/046/727/15af465f00643d9294c9baf4d4072f76b4802334.jpg"
  }, {
    name: "Ceri Dupree",
    mugshot_url: "http://old.whatsonlive.co.uk/UserFiles/Image/Artist/76075Da3f970.jpg"
  }, {
    name: "Chris Ramsey",
    mugshot_url: "http://www.chrisramseycomedy.com/uploaded/news/6a62d8e348e212e474e78cfadb54df64.jpg"
  }, {
    name: "Sue Perkins",
    mugshot_url: "http://cdn.images.express.co.uk/img/dynamic/39/285x214/112867_1.jpg"
  }, {
    name: "Bobby Davro",
    mugshot_url: "http://i3.mirror.co.uk/incoming/article7295599.ece/ALTERNATES/s1200/Comedian-and-actor-Bobby-Davro.jpg"
  }, {
    name: "David Baddiel",
    mugshot_url: "http://i4.mirror.co.uk/incoming/article6606881.ece/ALTERNATES/s1200/David-Baddiel.jpg"
  }, {
    name: "Andy Hamilton",
    mugshot_url: "http://cdn.bigissue.com/sites/bigissue/files/andy_hamilton.jpg"
  }, {
    name: "Nathan Caton",
    mugshot_url: "http://www.aberdeenperformingarts.com/uploads/event/nathan%20caton%20-%20box%20office_2.jpg"
  }, {
    name: "David O'Doherty",
    mugshot_url: "https://static2.stuff.co.nz/1336355211/144/6874144.jpg"
  }, {
    name: "Rob Brydon",
    mugshot_url: "http://www.unitedagents.co.uk/sites/default/files/BRYDONRnew.jpg"
  }, {
    name: "Adam Buxton",
    mugshot_url: "http://cdn.mos.cms.futurecdn.net/YnXae3iedZiLRzyWuSqpY8-480-80.jpg"
  }, {
    name: "Penn And Teller",
    mugshot_url: "http://static.tvtropes.org/pmwiki/pub/images/Penn-and-Teller_5945.jpg"
  }, {
    name: "Patrick Monahan",
    mugshot_url: "https://cotswoldcomedyclub.files.wordpress.com/2012/02/pat-monahan.jpg"
  }, {
    name: "Gervase Phinn",
    mugshot_url: "https://www.speakerscorner.co.uk/media/image/gervase-p.png"
  }, {
    name: "Mark Thomas",
    mugshot_url: "http://www.mtcp.co.uk/wp-content/uploads/2015/10/markrtyty.jpg"
  }, {
    name: "Hal Cruttenden",
    mugshot_url: "https://i0.wp.com/www.thereviewshub.com/wp-content/uploads/Screen-Shot-2015-08-19-at-08.46.08.png?fit=604%2C278"
  }, {
    name: "John Robins",
    mugshot_url: "https://media.timeout.com/images/102293363/image.jpg"
  }, {
    name: "The Rubberbandits",
    mugshot_url: "http://www.giaf.ie/content/gallery15/the_rubberbandits_gallery_02.jpg"
  }, {
    name: "The Barron Knights",
    mugshot_url: "http://static.wixstatic.com/media/3f1fb9_6b92887493be4955b2bc34f0689028cd~mv2.jpg_srz_306_230_85_22_0.50_1.20_0.00_jpg_srz"
  }, {
    name: 'Andrew Lawrence',
    mugshot_url: "http://www.andrewlawrencecomedy.co.uk/images/Andrew-Lawrence.jpg"
  }, {
    name: "Johnny Vegas",
    mugshot_url: "http://i4.liverpoolecho.co.uk/incoming/article6239916.ece/ALTERNATES/s615/zz211013vegas-1.jpg"
  }, {
    name: "Kevin Bloody Wilson",
    mugshot_url: "http://cdn.eventfinda.co.nz/uploads/artists/transformed/166228-739-7.jpg"
  }, {
    name: 'Barry Cryer',
    mugshot_url: "https://pbs.twimg.com/profile_images/621377002075987968/cmH3j6nE.jpg"
  }, {
    name: 'Gary Delaney',
    mugshot_url: "http://www.chateau-impney.com/images/content/Blog/comedy-night/comedy-night-boxpic--gd.jpg"
  }, {
    name: "Mae Martin",
    mugshot_url: "https://ichef.bbci.co.uk/images/ic/480xn/p00wtxkh.jpg"
  }, {
    name: 'Abi Roberts',
    mugshot_url: "https://s-media-cache-ak0.pinimg.com/236x/64/36/19/6436190d644136ce913cc88571f560b7.jpg"
  }, {
    name: 'Richard Blackwood',
    mugshot_url: 'http://keyassets-p2.timeincuk.net/wp/prod/wp-content/uploads/sites/42/2015/05/05-1431507204_3ba7d269cf7a309381577367be40a92b_600x973.jpg'
  }, {
    name: 'Stephen K Amos',
    mugshot_url: "http://www.local-choice.co.uk/media/uploads/Stephen-K-Amos-things-to-do-lancaster1.jpg"
  }, {
    name: 'Marcus Brigstocke',
    mugshot_url: "http://combiboilersleeds.com/images/marcus-brigstocke/marcus-brigstocke-2.jpg"
  }, {
    name: "Hardeep Singh Kohli",
    mugshot_url: "https://s-media-cache-ak0.pinimg.com/564x/46/a5/35/46a535ac3a772a4b576aa320a1170c7a.jpg"
  }, {
    name: "The Grumbleweeds",
    mugshot_url: 'http://cdn.images.express.co.uk/img/dynamic/20/590x/18f248newgrumble-423012.jpg'
  }, {
    name: "Paul Zerdin",
    mugshot_url: "http://www.tntmagazine.com/image.php/media/content/_master/45432/images/paul-z.jpg?file=media%2Fcontent%2F_master%2F45432%2Fimages%2Fpaul-z.jpg&width=450"
  }, {
    name: "Josie Long",
    mugshot_url: "http://www.josielong.com/images/gallery/www.josielong.com01.jpg"
  }, {
    name: "Richard Herring",
    mugshot_url: "http://avalonuk.com/wp-content/uploads/2015/02/Richard-Herring-1026x508.jpg"
  }, {
    name: "Richard Digance",
    mugshot_url: "http://newsimg.bbc.co.uk/media/images/47592000/jpg/_47592235_richard_digance.jpg"
  }, {
    name: "Pam Ayres",
    mugshot_url: "http://i.telegraph.co.uk/multimedia/archive/00428/travel-graphics-200_428963a.jpg"
  }, {
    name: "Kojo",
    mugshot_url: "https://theyoungempire.files.wordpress.com/2016/04/kojo.jpg"
  }, {
    name: "Phil Wang",
    mugshot_url: "https://files.list.co.uk/images/2016/03/29/phil-wang-avalon-image3-lst199601.jpg"
  }, {
    name: "Brendon Burns",
    mugshot_url: "http://static.guim.co.uk/sys-images/Technology/Pix/pictures/2008/11/20/brendon-burns460.jpg"
  }, {
    name: "Kieran Hodgson",
    mugshot_url: "http://www.unitedagents.co.uk/sites/default/files/KieranNewHeadshot1.jpg"
  }, {
    name: "Scott Capurro",
    mugshot_url: "http://www.culturenorthernireland.org/sites/default/files/styles/slideshow_-_non-scaled_full_width/public/cappuro.jpg?itok=UyYJiOuX"
  }, {
    name: "Kerry Godliman",
    mugshot_url: "https://broadwaybabycomedy.files.wordpress.com/2014/05/kerry-godliman-014.jpg"
  }, {
    name: "Susan Calman",
    mugshot_url: "http://broadwaybaby.com/img/shows/edinburgh-fringe/comedy/28108.jpg"
  }, {
    name: "Jonathan Pie",
    mugshot_url: "http://b247cdn.co.uk/21306/gallery/top/web/jonathan-pie-1479385677.jpg"
  }, {
    name: "Ivo Graham",
    mugshot_url: "http://www.funnybone.co.uk/wp-content/uploads/2014/05/Ivo-Graham1.jpg"
  }, {
    name: "Tudor Owen",
    mugshot_url: "http://i2.dailypost.co.uk/incoming/article2625116.ece/ALTERNATES/s615/pix-image-5-939985925.jpg"
  }, {
    name: "Zoe Lyons",
    mugshot_url: "http://comedystoreuk.wpengine.netdna-cdn.com/london/wp-content/uploads/sites/4/2013/10/Zoe-Lyons-205-x-205.jpg"
  }, {
    name: "Tony Law",
    mugshot_url: "http://www.theskinny.co.uk/assets/production/000/114/804/114804_large.jpg"
  }, {
    name: "Craig Hill",
    mugshot_url: "http://files.stv.tv/imagebase/271/650x366/271305-craig-hill.jpg"
  }, {
    name: "Bob Mills",
    mugshot_url: "http://waytofamous.com/images/bob-mills-08.jpg"
  }, {
    name: "Conal Gallen",
    mugshot_url: "http://www.advertiser.ie/images/2015/10/79985.jpg"
  }, {
    name: "Stavros Flatley",
    mugshot_url: "http://i1.mirror.co.uk/incoming/article400542.ece/ALTERNATES/s1200/cos-stavros-flatley-image-1-923821009.jpg"
  }, {
    name: "Jimeoin",
    mugshot_url: "http://cdn.newsapi.com.au/image/v1/2974408b5bd12662e1dda90008121aee"
  }, {
    name: "Mick Miller",
    mugshot_url: "http://staffslive.co.uk/wp-content/uploads/2013/02/Mick_Miller.jpg"
  }, {
    name: "Dave Spikey",
    mugshot_url: "http://musicandbands.co.uk/wp-content/uploads/2014/05/Dave-Spikey-Main.jpg"
  }, {
    name: "Grant Stott",
    mugshot_url: "http://www.alledinburghtheatre.com/wp-content/uploads/2016/08/Tales-Standing1-538x316.jpg"
  }, {
    name: "Jake O'Kane",
    mugshot_url: "http://www.irishnews.com/picturesarchive/irishnews/irishnews/2015/12/09/215212366-3249d891-602b-4fda-a135-8f78c39ac144.jpg"
  }, {
    name: "Cecilia Delatori",
    mugshot_url: "https://pbs.twimg.com/profile_images/3235445019/4a3304fd23f9415706abe9a6563546a6_400x400.jpeg"
  }, {
    name: "Arthur Smith",
    mugshot_url: "https://www.neweurope.eu/wp-content/uploads/2013/01/www_arthursmith_co_uk-black_white_promo.jpg"
  }, {
    name: "Tom Green",
    mugshot_url: "https://s3-us-west-2.amazonaws.com/wiseguyscomedy.com/media/33/profile.jpg"
  }, {
    name: "Alan Davies",
    mugshot_url: "https://static2.stuff.co.nz/1359861068/636/8257636.jpg"
  }, {
    name: "Brennan Reece",
    mugshot_url: "http://i1.manchestereveningnews.co.uk/incoming/article9733791.ece/ALTERNATES/s615b/JS68928204.jpg"
  }, {
    name: "Mrs Barbara Nice (Janice Connolly)",
    mugshot_url: "http://i4.examiner.co.uk/incoming/article6844163.ece/ALTERNATES/s615/House.jpg"
  }, {
    name: "Paul Foot",
    mugshot_url: "http://www.rrr.org.au/assets/paulfoot_cropped_230x250.jpg"
  }, {
    name: "Rosie And Rosie",
    mugshot_url: "https://ichef.bbci.co.uk/images/ic/640x360/p02lb5tc.jpg"
  }, {
    name: "John Challis",
    mugshot_url: "http://images.dailystar.co.uk/dynamic/117/photos/931000/111931.jpg"
  }, {
    name: "Imran Yusuf",
    mugshot_url: "http://backyardbar.co.uk/wp-content/uploads/2013/11/Imran-Yusuf.jpg"
  }, {
    name: "Richard Gadd",
    mugshot_url: 'http://www.unitedagents.co.uk/sites/default/files/Gadd%20R%20(New%20-%20Low%20Res).jpg'
  }, {
    name: "Dillie Keane",
    mugshot_url: 'https://www.comedy.co.uk/images/library/fringe/2015/250x250/dillie_keane.jpg'
  }, {
    name: "Mr B The Gentleman Rhymer",
    mugshot_url: 'https://www.comedy.co.uk/images/library/fringe/2013/250x250/mr_b_the_gentleman_rhymer.jpg'
  }, {
    name: "Phil Beer Band",
    mugshot_url: 'http://media.ents24network.com/image/000/202/392/5667a791b473183d260ecc50914f8d1033eb95c6.jpg'
  }, {
    name: "Comedy Club 4 Kids",
    mugshot_url: "http://www.thelowry.com/Images/Brochure51/Comedy_4_Kids_main.jpg"
  }, {
    name: "Des Clarke",
    mugshot_url: "https://www.desclarke.com/wp-content/uploads/2015/03/des-300.png"
  }, {
    name: "Larry Dean",
    mugshot_url: "https://pbs.twimg.com/media/C19m2-VXAAAMzEV.jpg"
  }, {
    name: "The Manc Lads",
    mugshot_url: "https://d31fr2pwly4c4s.cloudfront.net/e/2/4/934351_1_the-manc-lads-live-in-stoke_400.jpg"
  }, {
    name: "Josh Howie",
    mugshot_url: "http://media.ents24network.com/image/000/121/011/733f00d32fecf7e0e562bce2319281df60693d4b.jpg"
  }, {
    name: "Brian Gittins",
    mugshot_url: "http://media.ents24network.com/image/000/022/032/8c9d5cb81e0610667403db48794614aa3640103a.jpg"
  }, {
    name: "Jason Cook",
    mugshot_url: "https://www.comedy.co.uk/images/library/people/900x450/j/jason_cook.jpg"
  }, {
    name: "Sofie Hagen",
    mugshot_url: 'http://www.getcomedy.com/blog/wp-content/uploads/2014/04/Sofie2.jpg'
  }, {
    name: "Toby Foster",
    mugshot_url: "http://az836445.vo.msecnd.net/cache/f/f/c/6/2/6/ffc626b68e9814bbcd312f659504e81197739798.jpg"
  }, {
    name: "Phil Hammond",
    mugshot_url: "http://rbmcomedy.com/photographs/phil_hammond_172.jpg"
  }, {
    name: "Yuriko Kotani",
    mugshot_url: "https://media.timeout.com/images/102409273/image.jpg"
  }, {
    name: "Barry From Watford",
    mugshot_url: "http://www.bbc.co.uk/staticarchive/469656757c1deb8aca12d001b4885674f118ee4f.jpg"
  }, {
    name: "Lee Hurst",
    mugshot_url: "http://cdn.images.express.co.uk/img/dynamic/11/285x214/294611_1.jpg"
  }, {
    name: "Al Porter",
    mugshot_url: 'http://www.irishexaminer.com/remote/media.central.ie/media/images/a/AlPorterSept19pic2_large.jpg?width=648&s=ie-354588'
  }, {
    name: "Simon Munnery",
    mugshot_url: 'https://www.exeterphoenix.org.uk/wp-content/uploads/2013/06/simon_munnery.jpg'
  }, {
    name: "Janey Godley",
    mugshot_url: 'https://files.list.co.uk/images/2013/07/19/janey2009bcreditsteveullath.jpg'
  }, {
    name: "Eleanor Conway",
    mugshot_url: 'http://www.mlatalent.com/wp-content/uploads/2016/09/Eleanor-Conway.jpg'
  }, {
    name: "Marcel Lucont",
    mugshot_url: 'http://www.gigglebeats.co.uk/wp-content/uploads/Marcel-Lucont.jpg'
  }, {
    name: "Mark Cooper-Jones",
    mugshot_url: 'http://broadwaybaby.com/img/shows/edinburgh-fringe/comedy/700951.jpg'
  }, {
    name: "Jenny Eclair",
    mugshot_url: 'http://www.beyondthejoke.co.uk/sites/default/files/jennyeclair-eclairious-1-lst104843.jpg'
  }, {
    name: "Shazia Mirza",
    mugshot_url: "http://www.hamhigh.co.uk/polopoly_fs/1.4244693.1443021968!/image/image.jpg_gen/derivatives/landscape_630/image.jpg"
  }, {
    name: "Dane J Baptiste",
    mugshot_url: "https://pbs.twimg.com/profile_images/2093244072/dane-121_20copy.jpg"
  }, {
    name: "Jeff Innocent",
    mugshot_url: 'http://www.wow247.co.uk/wp-content/uploads/2015/07/jeff_innocent_press.jpg'
  }, {
    name: "David Walliams",
    mugshot_url: 'https://static.standard.co.uk/s3fs-public/thumbnails/image/2016/04/17/17/david-walliams.jpg'
  }, {
    name: "Bobby Mair",
    mugshot_url: 'https://files.list.co.uk/images/2014/02/25/images.list.co.uk_bobby-mai.jpg'
  }, {
    name: "Robin Ince",
    mugshot_url: 'https://worldofbooksblog.files.wordpress.com/2011/12/robin-ince.jpg'
  }, {
    name: "Ellie Taylor",
    mugshot_url: "http://picswall.net/wp-content/uploads/2016/09/Ellie-Taylor-Wallpaper-HD.jpg"
  }, {
    name: "Ed Gamble",
    mugshot_url: "http://camdencomedyclub.com/wp-content/uploads/2016/01/Ed-GAmble-2.jpg"
  }, {
    name: "Jo Caulfield",
    mugshot_url: "https://www.scotsmagazine.com/wp-content/uploads/sites/7/2015/12/Jo-Caulfield-Carousel.jpg"
  }, {
    name: "Abandoman",
    mugshot_url: "http://static.wixstatic.com/media/cc33eb_2ff68ad1e9794e0ab17cc45a63467ebc.jpg"
  }, {
    name: "Stuart Goldsmith",
    mugshot_url: "https://www.comedy.co.uk/images/library/fringe/2014/250x250/stuart_goldsmith.jpg"
  }, {
    name: "Raymond Mearns",
    mugshot_url: "http://media.livenationinternational.com/lincsmedia/Media/x/g/v/c6633a99-7112-48fc-8d8b-c9ffb54516b7.jpg"
  }, {
    name: "Geoff Norcott",
    mugshot_url: "https://files.list.co.uk/images/2013/08/14/geoff-norcott-edinburgh-201.jpg"
  }, {
    name: "Dave Gorman",
    mugshot_url: "http://waytofamous.com/images/dave-gorman-03.jpg"
  }, {
    name: "Kane Brown",
    mugshot_url: "http://media.ents24network.com/image/000/071/475/81819d253bb0d0cd13c3366a9353fbab9de289ec.jpg"
  }, {
    name: "Slim",
    mugshot_url: "http://media.ents24network.com/image/000/171/382/d9525872894cec9a5dc0dcd2991b002042e549e3.jpg"
  }, {
    name: "Axel Blake",
    mugshot_url: "http://media.ents24network.com/image/000/171/382/d9525872894cec9a5dc0dcd2991b002042e549e3.jpg"
  }, {
    name: "Kojo",
    mugshot_url: "http://resources4.atgtickets.com/static/20410_full.jpg"
  }, {
    name: "Joe Wells",
    mugshot_url: "http://www.newtheatreroyal.com/wp-content/uploads/2015/02/square300joe.png"
  }, {
    name: "The Lancashire Hotpots",
    mugshot_url: "https://media.ents24network.com/image/000/090/521/35098fd398a451f0e82cf2b074ac8a15543b03d5.jpg"
  }, {
    name: "Justin Moorhouse",
    mugshot_url: "http://resources1.atgtickets.com/static/1932_full.jpg"
  }, {
    name: "Tommy Tiernan",
    mugshot_url: "http://www.balorartscentre.com/wp-content/uploads/2015/09/ttweb.jpg"
  }, {
    name: "Iain Stirling",
    mugshot_url: "http://broadwaybaby.com/img/shows/edinburgh-fringe/comedy/29088.jpg"
  }, {
    name: "Phil Tufnell",
    mugshot_url: "http://i.dailymail.co.uk/i/pix/2014/01/27/article-2546630-1AFB0B4F00000578-858_306x423.jpg"
  }, {
    name: "Lloyd Griffith",
    mugshot_url: "http://broadwaybaby.com/img/shows/edinburgh-fringe/comedy/706088.jpg"
  }, {
    name: "Puppetry of the Penis",
    mugshot_url: "https://i.gse.io/gse_media/110/0/780028-puppetry-of-t.jpg?p=1"
  }, {
    name: "The Spooky Men's Chorale",
    mugshot_url: "http://media.ents24network.com/image/000/029/404/12520243aef4c308519b5b6b25c6ed8cce1b4ed0.jpg"
  }, {
    name: "Wells Comedy Festival",
    mugshot_url: "http://brotherscider.co.uk/dynamic/thumbs/243x243e/1487153634Wells-Comedy-Festival-2017.jpg"
  }, {
    name: "Phil Nichol",
    mugshot_url: "https://www.comedy.co.uk/images/library/fringe/2016/250x250/phil_nichol.jpg"
  }, {
    name: "Colin Cole",
    mugshot_url: "http://comicus.co.uk/wp-content/uploads/2014/09/colin-cole.jpg"
  }, {
    name: "Jarred Christmas",
    mugshot_url: "http://www.get-stuffed.biz/files/2013/6396/0212/Jarred_Christmas_by_Claes_Gellerbrink_1865.jpg"
  }, {
    name: "Jay Rayner",
    mugshot_url: "http://www.lancashiretelegraph.co.uk/resources/images/2855490/"
  }, {
    name: "Tez Ilyas",
    mugshot_url: "http://www.aaaedinburgh.co.uk/wp-content/uploads/2015/08/tez_ilyaz_comedy_edinburgh-563x353.jpg",
  }, {
    name: "Fred MacAulay",
    mugshot_url: "https://files.list.co.uk/images/festivals/2013/fringe/fred-macaulay-25-fringes-31111-300.jpg"
  }, {
    name: "Adam Kay",
    mugshot_url: "http://www.discoverthebluedot.com/gfx/profiles_83.png"
  }, {
    name: "Ali Cook",
    mugshot_url: "https://upload.wikimedia.org/wikipedia/en/b/b5/Ali_Cook,_Magician_and_Actor.jpg"
  }, {
    name: "The Dolls",
    mugshot_url: "http://www.tron.co.uk/docs/059_305__thedolls_1375100745_standard.jpg"
  }, {
    name: "Matt Forde",
    mugshot_url: "https://media.timeout.com/images/100781539/image.jpg"
  }, {
    name: "John Kearns",
    mugshot_url: "http://londonisfunny.com/wp-content/uploads/2014/05/John_Kearns2.jpg"
  }, {
    name: "The Noise Next Door",
    mugshot_url: "http://assets.londonist.com/uploads/2013/05/the-noise-next-door.jpg"
  }, {
    name: "MC Devvo",
    mugshot_url: "http://www.sickchirpse.com/wp-content/uploads/2014/07/Devvo-BW.jpg"
  }, {
    name: "Tiffany Stevenson",
    mugshot_url: "https://www.comedy.co.uk/images/library/people/900x450/t/tiffany_stevenson.jpg"
  }, {
    name: "Abi Roberts",
    mugshot_url: "http://broadwaybaby.com/img/uploaded/016_Abi_Roberts_hub.jpg"
  }, {
    name: "Carl Hutchinson",
    mugshot_url: "http://avalonuk.com/wp-content/uploads/2015/03/CARL-HUTCHINSON-1026x507.jpg"
  }, {
    name: "The Alternative Comedy Memorial Society",
    mugshot_url: "https://media.ents24network.com/image/000/236/000/6b75ca989bdea29c0ea7a8bd7224c7ea2f79338b.jpg"
  }, {
    name: "Jen Brister",
    mugshot_url: "http://funnywomen.com/wp-content/uploads/2016/10/jenbristercropin.jpg"
  }, {
    name: "The Comedy Store Players",
    mugshot_url: "https://media.timeout.com/images/10471/630/472/image.jpg"
  }, {
    name: "Neil Delamere", 
    mugshot_url: "http://cdn4.rosannadavisonnutrition.com/wp-content/uploads/2016/11/32774_70_pages_05_16282_600x458.jpg"
  }, {
    name: "Foil Arms And Hog",
    mugshot_url: "http://totallydublin.ie/wp-content/uploads/2014/04/FAHSTUDIO-702.jpg"
  }, {
    name: "Pete Johansson",
    mugshot_url: "http://www.getcomedy.com/blog/wp-content/uploads/2015/02/PeteJohansson-565x286.jpg"
  }, {
    name: "Adam Hess",
    mugshot_url: "https://static.standard.co.uk/s3fs-public/thumbnails/image/2015/08/17/15/adamhess1708a.jpg"
  }, {
    name: "Mik Artistik's Ego Trip",
    mugshot_url: "http://www.northleedslifegroup.com/wp-content/uploads/2014/03/Mik-Artistiks-Ego-Trip.jpg"
  }, {
    name: "Pam Ann",
    mugshot_url: "http://images.smh.com.au/2012/07/31/3515028/Pam-Ann-vid-620x349.jpg"
  }, {
    name: "Circus Hilarious",
    mugshot_url: "http://media.ticketmaster.co.uk/tm/en-gb/dbimages/25029a.jpg"
  }, {
    name: "Fizzog Productions",
    mugshot_url: "https://pbs.twimg.com/media/B7T8aCdIYAAac-x.jpg"
  }, {
    name: "Barry Dodds",
    mugshot_url: "http://assets2.livebrum.com/images/manfords-comedy-club/clax/home/barry-dodds-adam-rowe-and-dana-alexander-1419413012.jpg"
  }, {
    name: "Micky Bartlett",
    mugshot_url: "http://www.irishnews.com/picturesarchive/irishnews/irishnews/2015/09/08/143702918-1c544285-4cf1-40eb-af78-c8242679ae90.jpg"
  }, {
    name: "Kevn McAleer",
    mugshot_url: "http://www.irishtimes.com/polopoly_fs/1.1533342.1379954274!/image/image.jpg_gen/derivatives/box_620_330/image.jpg"
  }, {
    name: "Nish Kumar",
    mugshot_url: "http://sohotheatre.com/files/images/applicationfiles/622.9352.NishImage.jpg/320x320.fitandcrop.jpg"
  }, {
    name: "Andy Askins",
    mugshot_url: "http://www.getcomedy.com/images/comedians/main/andyaskins01.jpg"
  }, {
    name: "Ashley Blaker",
    mugshot_url: "https://pbs.twimg.com/media/C3gG_grWIAAhzLS.jpg"
  }, {
    name: "Adam Bloom",
    mugshot_url: "http://i1.chesterchronicle.co.uk/incoming/article11110167.ece/ALTERNATES/s615/MGR_TCH_290316ADAM_01.jpg"
  }, {
    name: "Greg Proops",
    mugshot_url: "http://www.gosuperego.com/wp-content/uploads/2012/03/Greg-Proops.jpg"
  }, {
    name: "Morgan and West",
    mugshot_url: "http://exeuntmagazine.com/wp-content/uploads/Morgan-West-600x566.jpg"
  }, {
    name: "Katy Brand",
    mugshot_url: "http://www3.pictures.zimbio.com/gi/Nanny+McPhee+Bang+World+Film+Premiere+Outside+3rxmstNn9Pml.jpg"
  }, {
    name: "Nicholas Parsons",
    mugshot_url: "https://ichef.bbci.co.uk/images/ic/1200x675/p01lcfxt.jpg"
  }, {
    name: "Carl Donnelly",
    mugshot_url: "https://i.guim.co.uk/img/static/sys-images/Guardian/Pix/pictures/2013/12/2/1385998471291/Carl-Donnelly-standup-com-008.jpg?w=300&q=55&auto=format&usm=12&fit=max&s=dfbaea429d606e959b60dc7754d2f678"
  }, {
    name: "Andy Robinson",
    mugshot_url: "http://offthekerb.co.uk/wp-content/uploads/2011/07/andy-robinson-2.jpg"
  }, {
    name: "Mishka Shubaly",
    mugshot_url: "http://sexpotcomedy.com/wp-content/uploads/2016/12/Ep230_pic.jpg"
  }, {
    name: "Scott Capurro",
    mugshot_url: "https://media.timeout.com/images/79897/660/370/image.jpg"
  }, {
    name: "Eddie 'The Eagle' Edwards",
    mugshot_url: "http://cdn.images.express.co.uk/img/dynamic/1/285x214/9410_1.jpg"
  }, {
    name: "Meryl O'Rourke",
    mugshot_url: "http://www.comedycv.co.uk/merylorourke/meryl-orourke-2014-may.jpg"
  }, {
    name: "Funmbi Omotayo",
    mugshot_url: "https://www.artsawardvoice.com/filesystem/auto_cropped/aside/3ae748a99ca3fb777ed80f17986d1d3e65bca874.jpg"
  }, {
    name: "Terry Alderton",
    mugshot_url: "http://platform-online.net/wp-content/uploads/2013/03/TerryA_Image1-crop-CREDIT-steve-ullathorne.jpg"
  }, {
    name: "Junior Simpson",
    mugshot_url: "http://www.nmplive.co.uk/media/gfx/1054.jpg"
  }, {
    name: "Sean McLoughlin",
    mugshot_url: "https://s-media-cache-ak0.pinimg.com/564x/25/9a/94/259a94b4ff4742f363345aabe1201ac8.jpg"
  }, {
    name: "Alistair Barrie",
    mugshot_url: "http://www.theskinny.co.uk/assets/production/36844/36844_widescreen.jpg"
  }, {
    name: "Jeff Dunham",
    mugshot_url: "https://pbs.twimg.com/profile_images/644984528419684352/uULaGCSH.jpg"
  }, {
    name: "Rob Rouse",
    mugshot_url: "http://assets3.radiox.co.uk/2013/32/rob-rouse-1376751777-hero-wide-0.jpg"
  }, {
    name: "Roger Monkhouse",
    mugshot_url: "http://www.theatkinson.co.uk/website/wp-content/uploads/2014/06/roger.jpg"
  }, {
    name: "Claire Parker",
    mugshot_url: "http://comedycv.co.uk/claireparker/claire-parker-2010-october.jpg"
  }, {
    name: "Alex Kealy",
    mugshot_url: "http://broadwaybaby.com/img/uploaded/alex_kealy_hub.jpg"
  }, {
    name: "Jonny Awsum",
    mugshot_url: "https://i.ebayimg.com/00/s/MjcwWDM1OA==/z/yM0AAOSwTglYkg6N/$_86.JPG"
  }, {
    name: "Iain Connell and Robert Florence",
    mugshot_url: "http://i3.dailyrecord.co.uk/incoming/article919374.ece/ALTERNATES/s615/burnistoun-image-4-735260457.jpg"
  }, {
    name: "Mitch Benn",
    mugshot_url: "http://i3.getreading.co.uk/incoming/article4730045.ece/ALTERNATES/s1200/Mitch-Benn.jpg"
  }, {
    name: "John Ryan",
    mugshot_url: "http://www.barnstormerscomedy.com/img/performers/954-1-144x214.jpg"
  }, {
    name: "John Hegley",
    mugshot_url: "http://archive.camdennewjournal.com/sites/all/files/nj_camden/imagecache/main_img/images/news/inews060311_08.jpg"
  }, {
    name: "The Houghton Weavers",
    mugshot_url: "http://www.coliseum.org.uk/wp-content/uploads/2014/05/The-Houghton-Weavers-header-700x394.jpg"
  }, {
    name: "Professor Elemental",
    mugshot_url: "https://static.designmynight.com/uploads/2017/01/prof-el-optimised.jpg"
  }, {
    name: "Jessica Fostekew",
    mugshot_url: "http://assets.londonist.com/uploads/2013/07/jessicafostekew.jpg"
  }, {
    name: "Tanyalee Davis",
    mugshot_url: "http://tanyaleedavis.com/wp-content/uploads/2015/06/IMG_4771.jpg"
  }, {
    name: "Pete Firman",
    mugshot_url: "http://i1.gazettelive.co.uk/incoming/article3605975.ece/ALTERNATES/s615/featured-pete-firman-502287088.jpg"
  }, {
    name: "Laura Lexx",
    mugshot_url: "https://blogs.kent.ac.uk/arts-news/files/2016/02/Laura-Lexx-Edinburgh-slider-404x330.jpg"
  }, {
    name: "Sloane Crosley",
    mugshot_url: "http://img.timeinc.net/time/daily/2010/1007/360_sloane_crosley_0713.jpg"
  }, {
    name: "Edward Aczel",
    mugshot_url: "https://media.timeout.com/images/100756013/image.jpg"
  }, {
    name: "Sophie Willan",
    mugshot_url: "http://www.theskinny.co.uk/assets/production/000/115/678/115678_widescreen.jpg"
  }, {
    name: "Rachel Parris",
    mugshot_url: "https://f4.bcbits.com/img/a1248436874_10.jpg"
  }, {
    name: "Seymour Mace",
    mugshot_url: "http://i3.chroniclelive.co.uk/incoming/article9948317.ece/ALTERNATES/s615/JS31445529.jpg"
  }, {
    name: "Rob Deering",
    mugshot_url: "https://www.comedy.co.uk/images/library/fringe/2014/250x250/rob_deering.jpg"
  }, {
    name: 'Josh Howie',
    mugshot_url: 'http://media.ents24network.com/image/000/121/011/733f00d32fecf7e0e562bce2319281df60693d4b.jpg'
  }, {
    name: 'Angela Barnes',
    mugshot_url: 'https://www.comedy.co.uk/images/library/fringe/2015/250x250/angela_barnes.jpg'
  }, {
    name: 'Nick Revell',
    mugshot_url: 'http://www.comedycv.co.uk/nickrevell/nick-revell-2016-november.jpg'
  }, {
    name: 'Rik Carranza',
    mugshot_url: 'http://events.liveguide.com.au-new.s3-ap-southeast-2.amazonaws.com/1081607_thumbnail_280_Rik_Carranza_Rik_Carranza_Charming.v1.jpg'
  }, {
    name: 'Alfie Moore',
    mugshot_url: 'http://media.ents24network.com/image/000/103/846/25f6e84f268bbb2df1bd4dfefcff9b34967d05a4.jpg'
  }, {
    name: 'Michael Fabbri',
    mugshot_url: 'http://assets3.livebrum.com/images/jongleurs-comedy-club/dkja/home/tom-toal-michael-fabbri-nick-page-1480765876.jpg'
  }, {
    name: 'The Amazing Bubble Man',
    mugshot_url: 'http://norden.farm/system/events/images/000/000/459/original/The_Amazing_Bubble_Man_LargeHandBubble_reduced.jpg?1486722852'
  }, {
    name: 'Andy Wilkinson',
    mugshot_url: 'http://media.ents24network.com/image/000/256/222/57aafbab943d0974350e7a139fa5de5a5dbb188d.jpg'
  }, {
    name: 'Rudi Lickwood',
    mugshot_url: 'https://thecomedyclub.co.uk/comedian_images/_comedianProfile/rdui2.jpg'
  }, {
    name: 'Mike Gunn',
    mugshot_url: 'http://www.edp24.co.uk/polopoly_fs/1.899876!/image/4132713901.jpg_gen/derivatives/landscape_490/4132713901.jpg'
  }, {
    name: 'Paul McCaffrey',
    mugshot_url: 'http://backyardbar.co.uk/wp-content/uploads/2014/01/paul-mccaffrey_4.jpg'
  }, {
    name: 'Scott Gibson',
    mugshot_url: 'http://www.thenational.scot/resources/images/5970974.jpg?display=1&htype=0&type=responsive-gallery'
  }, {
    name: 'Tom Glover',
    mugshot_url: 'http://3.bp.blogspot.com/-bwcGUUHotA0/TyAeytQKdUI/AAAAAAAADLI/TXRYDZCHNmM/s1600/Tom_Glover.jpg'
  }, {
    name: 'Graffiti Classics',
    mugshot_url: 'http://legacymedia.localworld.co.uk/275784/Article/images/18182247/4574325.jpg'
  }, {
    name: 'Phil Ellis',
    mugshot_url: 'http://www.justthetonic.com/artistimages/phil-ellis/feature/phil-ellis_1.jpg'
  }, {
    name: "Simon Amstell",
    mugshot_url: "https://s-media-cache-ak0.pinimg.com/originals/d5/12/63/d51263f2fe67b9341f0682a4f1229d2d.png"
  }, {
    name: "Gabriel Iglesias",
    mugshot_url: "http://1.images.comedycentral.com/images/ccstandup/comedians/800x600/gabriel_iglesias2_800x600.jpg?width=800&height=600&crop=true&quality=0.91"
    }]

  comedians_info.each do |comedian_info|

    begin
      ap "Processing mugshot for #{comedian_info[:name]} ..."
      Comedian.delay.find_or_create_with_mugshot(comedian_info)
      ap '...Processed and queued!'

    rescue Exception => e 
      ap "Oh no! #{e.message}"
    end
  end

  
end
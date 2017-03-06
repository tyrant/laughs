function FAQs() {

  // Just static HTML, no state or computation here.
  return (
    <div className="panel-group" id="faq_accordion" role="tablist" aria-multiselectable="true">

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingZero">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseZero" aria-expanded="true" aria-controls="collapseZero">
              This website map thingy looks great, but ... er, what's it actually about?
            </a>
          </h4>
        </div>
        <div id="collapseZero" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingZero">
          <div className="panel-body">
            <p>
              Good question! So I'm a big fan of standup comedy. I live in Wellington, New Zealand. I might walk through town and spy a poster of, say, Jimmy Carr, or Eddie Izzard, or another big international act. Hey great, they're doing a gig!
            </p>
            <p>
              Then I walk closer ... and turns out they came and went three months ago. Damn and blast and Gaddafi's loathsome undies.
            </p>
            <p>
              So I figured ... hang on, these comics all have websites. Websites with Upcoming Gigs pages. Full of gigs, and ticket links. Let's help them out! Let's write an app that grabs that info and displays it on a map.
            </p>
            <p>
              This is it. Enjoy!
            </p>
          </div>
        </div>
      </div>

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingOne">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
              My favourite comedian isn't on here! What gives?
            </a>
          </h4>
        </div>
        <div id="collapseOne" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
          <div className="panel-body">
            <p>
              And here's me claiming your favourite comic is already here! My bad :( Problem is, I have to write a separate script to get the data for each comic, and that shit takes time. I'm adding them as fast as I can. If you'd like me to bump your comic up the list, flick me an email at epicschnozz[at]gmail[dot]com.
            </p>
            <p>
              That said, sometimes I've tried to add comedians and couldn't. Sarah Millican, Ricky Gervais, others, they're just not touring right now. <a href="http://www.sarahmillican.co.uk/live-tour">See?</a>
            </p>
            <p>
              Then again, I did write these words way back in January 2017. In whatever Star Trek future you're reading this in, maybe she's started touring again. 
            </p>
          </div>
        </div>
      </div>

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingFour">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseFour" aria-expanded="true" aria-controls="collapseFour">
              My favourite comedian <em>is</em> on here, but they have no gigs! What gives?
            </a>
          </h4>
        </div>
        <div id="collapseFour" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
          <div className="panel-body">
            <p>
              One of two reasons: I've either not got around to writing their website-parsing scripts, or I've attempted to and it turns out their site is unparseable. <a href="http://www.robbeckettcomedy.com/">Rob Beckett's site</a> is such a website. Looks great! Until you realise each gig listing just mentions the city and not the venue. You can't automatically get each venue's exact location without major fiddliness.
            </p>
          </div>
        </div>
      </div>

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingTwo">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
              Your app seems kinda cool. Can I install it on my own website?
            </a>
          </h4>
        </div>
        <div id="collapseTwo" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
          <div className="panel-body">
            <p>
              Please do! Here's how:
            </p>
            <p>
              First, adjust the map, search form and tabs to display the way you'd like. You'll notice that with each tweak, the URL changes to match. Once you're satisfied, copy it.
            </p>
            <p>
              Second, add this code to your site:
            </p>
            <p>
              <code>
                &lt;iframe<br/>
                  width="<em>Your pixel width here</em>"<br/>
                  height="<em>Your pixel height here</em>"<br/>
                  src="<em>Your copied-and-pasted URL here</em>"&gt;<br/>
                &lt;/iframe&gt;
              </code>
            </p>
            <p>
              And that's it! The embedded widget will behave exactly as a normal web page.
            </p>
          </div>
        </div>
      </div>

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingThree">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
              Sometimes a venue is located with the right city name, but in the wrong country! What's the deal?
            </a>
          </h4>
        </div>
        <div id="collapseThree" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
          <div className="panel-body">
            <p>
              Rr, I know. It's a colossal pain in the ass for me too.
            </p>
            <p>
              Here's the deal. I shall make an example of Omid Djalili. The problem extends far further than just him, but his website is exceptionally heinous to extract consistent data from, so he can get stuffed.
            </p>
            <p>
              Consider this search: <a href="scicencethisbitchup.com/?v=none&g=s&t=search&c=22&a=-33.502522&n=101.506165&z=3&o=t&s=1487674800&e=1487761200">scicencethisbitchup.com/?v=none&g=s&t=search&c=22&a=-33.502522&n=101.506165&z=3&o=t&s=1487674800&e=1487761200</a>. If I've got my data right, it shows exactly one of his gigs - located in Perth, Australia. If you check the webpage I've lovingly swiped that gig, and others, off, <a href="http://www.omidnoagenda.com/omiddjalilievent.html">http://www.omidnoagenda.com/omiddjalilievent.html</a>, you'll see his February 22 2017 gig is indeed in "Perth" - but it's his UK tour. This Perth is in Scotland. My web scripts have to iterate over his page, you see, line by line, and the only content I'm able to relay to Google's Place APIs is "PERTH CONCERT HALL". 
            </p>
            <p>
              Aspiring script kiddies will no doubt retort "but why cant u append UNITED KINGDOM fr each row to ur API calls?" Fair point, I could - but that'd then muck up the December 2016 international gigs, further up the page. Now, could I write yet another test to distinguish local gigs from international? Yyyyes - but, when I write a script to extract a site's precious gig info, it's got to be automatic. When Omid adds a gig to his page, my script has to read and copy that gig into my server database, automatically, accurately, without me having to keep tabs on it. And when the raw data is this clunky, that just ain't gonna happen.
            </p>
            <p>
              I've spent all morning battling Omid's quirks. I'll do my best to work around them, but at some point you just have to say screw it. I've sunk enough time polishing your turd. You write crap gig info, I'll display that crap gig info. Your groupies shall toddle to Australia.
            </p>
            <p>
              But ... I honestly don't intend that to sound as rude as it does! Sorry, Omid! I doubt that (1) you update your own site, or that (2) you're a techie. You and other non-techies might look at the events page and think "It's not <em>that</em> bad, is it? It's in a ... <em>fairly</em> well formatted table, decent structure, what's the problem?"
            </p>
            <p>
              Fair points. Problem is, this one page has a zillion fiddly edge cases. I've only mentioned a few above. Other websites are far better, though. There are some real beauties out there. Check out <a href="http://gregdavies.co.uk/">Greg Davies's page</a>. Phwoar.
            </p>
            <p>
              And it could be worse, too. Look at Sara Pascoe's page: <a href="http://www.sarapascoe.com/gigs.html">http://www.sarapascoe.com/gigs.html</a> What's wrong with it, you may ask? Looks lovely! At face value why yes it does, until techies like me start digging into it - and turns out she's using some third-party embedded calendar app called Tockify. It's an entire Angular app. (For non-techies, Angular is a technical term meaning "overengineered"). And it actively fights back against being parsed. Hell of a shame, because I do love Sara's stuff, but I can't add her gigs to my site.
            </p>
          </div>
        </div>
      </div>

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingFive">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseFive" aria-expanded="false" aria-controls="collapseFive">
              What do all these map icons mean?
            </a>
          </h4>
        </div>
        <div id="collapseFive" className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingFive">
          <div className="panel-body">
            <p>
              <img src="/map-marker.png" />One of these babies denotes a single venue. Its number denotes how many gigs for it we've got on record.
            </p>
            <p>
              Otherwise, each of the icons below denotes any number of venues too closely packed to properly show at this zoom level. Double-click to zoom in closer.
            </p>
            <p>
              <img src="/m1.png" />1-9 venues
            </p>
            <p>
              <img src="/m2.png" />10-99 venues
            </p>
            <p>
              <img src="/m3.png" />100-999 venues
            </p>
            <p>
              <img src="/m4.png" />1000-9999 venues
            </p>
            <p>
              <img src="/m5.png" />10000+ venues
            </p>
          </div>
        </div>
      </div>

      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="heading6">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapse6" aria-expanded="false" aria-controls="collapse6">
              Where have you got your venue/gig data from?
            </a>
          </h4>
        </div>
        <div id="collapse6" className="panel-collapse collapse" role="tabpanel" aria-labelledby="heading6">
          <div className="panel-body">
            <p>
              Many websites have contributed! Here are a few:
            </p>
            <p>
              <a href="https://www.jimmycarr.com/live/?show=2017-uk-tour-dates">https://www.jimmycarr.com/live/?show=2017-uk-tour-dates</a>
            </p>
            <p>
              <a href="http://www.eddieizzard.com/shows">http://www.eddieizzard.com/shows</a>
            </p>
            <p>
              <a href="http://www.daraobriain.com/dates/">http://www.daraobriain.com/dates/</a>
            </p>
            <p>
              <a href="http://edbyrne.com/live-dates/">http://edbyrne.com/live-dates/</a>
            </p>
            <p>
              <a href="http://www.livenation.co.uk/artist/micky-flanagan-tickets">http://www.livenation.co.uk/artist/micky-flanagan-tickets</a>
            </p>
            <p>
              <a href="http://billburr.com/events/">http://billburr.com/events/</a>
            </p>
            <p>
              <a href="http://jimjefferies.com/events">http://jimjefferies.com/events</a>
            </p>
            <p>
              <a href="http://www.rhysdarby.com/gigs/">http://www.rhysdarby.com/gigs/</a>
            </p>
            <p>
              <a href="http://www.rossnoble.co.uk/tour/">http://www.rossnoble.co.uk/tour/</a>
            </p>
            <p>
              <a href="https://www.ents24.com/uk/tour-dates/sean-lock">https://www.ents24.com/uk/tour-dates/sean-lock</a>
            </p>
            <p>
              <a href="http://gregdavies.co.uk/">http://gregdavies.co.uk/</a>
            </p>
            <p>
              <a href="https://www.frankieboyle.com/">https://www.frankieboyle.com/</a>
            </p>
            <p>
              <a href="http://jonrichardsoncomedy.com/gigs/">http://jonrichardsoncomedy.com/gigs/</a>
            </p>
            <p>
              <a href="http://www.markwatsonthecomedian.com/category/live-shows/">http://www.markwatsonthecomedian.com/category/live-shows/</a>
            </p>
            <p>
              <a href="http://billbailey.co.uk/tour/">http://billbailey.co.uk/tour/</a>
            </p>
            <p>
              <a href="http://www.russell-howard.co.uk/">http://www.russell-howard.co.uk/</a>
            </p>
            <p>
              <a href="http://www.reginalddhunter.com/uk-tour-2017/">http://www.reginalddhunter.com/uk-tour-2017/</a>
            </p>
            <p>
              <a href="http://henningwehn.de/tour/">http://henningwehn.de/tour/</a>
            </p>
            <p>
              <a href="https://louisck.net/tour-dates">https://louisck.net/tour-dates</a>
            </p>
            <p>
              <a href="http://www.stereoboard.com/peter-kay-tickets">http://www.stereoboard.com/peter-kay-tickets</a>
            </p>
            <p>
              <a href="http://www.omidnoagenda.com/omiddjalilievent.html">http://www.omidnoagenda.com/omiddjalilievent.html</a>
            </p>
            <p>
              <a href="http://www.stewartlee.co.uk/live-dates/">http://www.stewartlee.co.uk/live-dates/</a>
            </p>
            <p>
              <a href="http://www.miltonjones.com/live">http://www.miltonjones.com/live</a>
            </p>
            <p>
              <a href="http://andyzaltzman.co.uk/shows/">http://andyzaltzman.co.uk/shows/</a>
            </p>
            <p>
              <a href="http://russellbrand.seetickets.com/tour/russell-brand/list/1/200">http://russellbrand.seetickets.com/tour/russell-brand/list/1/200</a>
            </p>
            <p>
              <a href="http://www.tomindeed.com/shows/">http://www.tomindeed.com/shows/</a>
            </p>
            <p>
              <a href="http://billyconnolly.com/tour">http://billyconnolly.com/tour</a>
            </p>
            <p>
              <a href="https://www.jackwhitehall.com/">https://www.jackwhitehall.com/</a>
            </p>
            <p>
              <a href="http://offthekerb.co.uk/on-tour/">http://offthekerb.co.uk/on-tour/</a>
            </p>
            <p>
              An extra-big thanks to <a href="http://nominatim.openstreetmap.org/">http://nominatim.openstreetmap.org/</a>, who have been kind enough to provide a public API to display place boundaries.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
function FAQs() {

  // Just static HTML, no state or computation here.
  return (
    <div className="panel-group" id="faq_accordion" role="tablist" aria-multiselectable="true">
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
        <div className="panel-heading" role="tab" id="headingTwo">
          <h4 className="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#faq_accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
              This comedy-search app thingy seems kinda cool. Can I install it on my own website?
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
              Consider this search: <a href="scicencethisbitchup.com/?v=none&g=s&t=search&c=22&a=-33.502522&n=101.506165&z=3&o=t&s=1487674800&e=1487761200">scicencethisbitchup.com/?v=none&g=s&t=search&c=22&a=-33.502522&n=101.506165&z=3&o=t&s=1487674800&e=1487761200</a>. If I've got my data right, it shows exactly one of his gigs - located in Perth, Australia. If you check the webpage I've lovingly swiped that gig, and others, off, <a href="http://www.omidnoagenda.com/omiddjalilievent.html">http://www.omidnoagenda.com/omiddjalilievent.html</a>, you'll see his February 22 2017 gig is indeed in Perth - but for the UK tour. Perth is in Scotland. My web scripts have to iterate over his page, you see, line by line, and the only content I can relay to Google's APIs is "PERTH CONCERT HALL". 
            </p>
            <p>
              Aspiring script kiddies will no doubt retort "but why cant u append UNITED KINGDOM to your API calls?" Fair point, I could - but that'd then muck up the December 2016 international gigs, further up the page. I've spent all morning countering Omid's quirks. It goes on and on and friggin' <em>on</em>. At some point you just have to say screw it, I've sunk enough time polishing your turd. You write shitty gig info, I'll display your shitty gig info.
            </p>
            <p>
              Don't get me wrong, I honestly don't intend that to sound as rude as it does! Non-techies might look at Omid's events page and think "It's not that bad, is it? It's in a ... <em>fairly</em> well formatted table, decent structure, what's the problem?"
            </p>
            <p>
              Fair points. Problem is, the site has a zillion fiddly edge cases. I've only mentioned a few here. There are some real beauties amongst the websites of today's comics, though. Check out Greg Davies's page. http://gregdavies.co.uk/ Phwoar.
            </p>
            <p>
              And it could be worse, too. Look at Sara Pascoe's page: http://www.sarapascoe.com/gigs.html At face value it looks just peachy, until techies like me start digging into it - and turns out she's using some third-party embedded calendar app called Tockify. It's an entire Angular app. (For non-techies, Angular is a technical term meaning "overengineered"). And it actively fights back against being parsed. Hell of a shame, because I love her stuff, but I can't add her gigs to my site.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
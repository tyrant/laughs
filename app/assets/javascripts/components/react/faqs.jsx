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
    </div>
  );
}
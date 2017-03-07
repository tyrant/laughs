class Ticker extends React.Component {


  constructor() {
    super();
  }


  render() {
    return (
      <div id="ticker">
        {this.props.blurbData.ajaxState == 'loading' ?
          <span id="blurb">
            <i className="fa fa-refresh fa-spin"></i> Just a sec <i className="fa fa-refresh fa-spin"></i>
          </span>
          :
          <span id="blurb">
            {this.props.blurbData.venues}&nbsp;
            {this.props.blurbData.venues == 1 ? 'venue' : 'venues'}
            ,&nbsp;
            {this.props.blurbData.gigs}&nbsp;
            {this.props.blurbData.gigs == 1 ? 'gig' : 'gigs'}
          </span>
        }
      </div>
    );
  }

}


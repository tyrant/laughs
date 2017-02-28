class Banner extends React.Component {

  constructor(props) {
    super(props);

    this.handleClick = this.handleClick.bind(this);
  }


  handleClick(e) {
    e.preventDefault();
    this.props.handleOverlayToggleClick();
  }


  render() {
    return (
      <div id="banner">
        <a id="home" className="btn btn-default" href="/">
          <i className="glyphicon glyphicon-home"></i>
        </a>
        {this.props.blurbData.ajaxState == 'loading' ?
          <span id="blurb">
            Loading venues and gigs... <i className="fa fa-refresh fa-spin"></i>
          </span>
          :
          <span id="blurb">
            Showing&nbsp;
            {this.props.blurbData.venues}&nbsp;
            {this.props.blurbData.venues == 1 ? 'venue' : 'venues'}
            ,&nbsp;
            {this.props.blurbData.gigs}&nbsp;
            {this.props.blurbData.gigs == 1 ? 'gig' : 'gigs'}
          </span>
        }
        <a id="toggle_overlay" className="btn btn-default" onClick={this.handleClick}>
          <span className="glyphicon glyphicon-list" aria-hidden="true"></span>
        </a>
      </div>
    );
  }
}
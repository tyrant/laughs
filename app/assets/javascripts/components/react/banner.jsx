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
        <span id="blurb">{this.props.blurb}</span>
        <a id="toggle_overlay" className="btn btn-default" onClick={this.handleClick}>
          <span className="glyphicon glyphicon-list" aria-hidden="true"></span>
        </a>
      </div>
    );
  }
}
class VenueInfo extends React.Component {

  constructor(props) {
    super(props);

    this.handleGigFilterChange = this.handleGigFilterChange.bind(this);
    this.getGigs = this.getGigs.bind(this);
  }


  handleGigFilterChange(e) {
    const value = e.target.value;
    this.props.handleGigFilterChange(value);
  }


  getGigs() {

    const gigs = this.props
      .currentVenue
      .gigs()
      .filteredByFormValues(this.props.gigFilters)
      .sortedByTime();

    return gigs;
  }

  render() {
    const venue = this.props.currentVenue;

    if (venue instanceof Venue) {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h4 className="panel-title">
              Gigs at {venue.get('name')}
            </h4>
            <label htmlFor="searched_gigs">
              <input 
                type="radio" 
                id="searched_gigs" 
                name="gig_filter" 
                value="s" 
                onChange={this.handleGigFilterChange}
                checked={this.props.gigFilters.gigFilter == 's'}
                />
              Matching your search
            </label>
            <label htmlFor="all_gigs">
              <input 
                type="radio" 
                id="all_gigs" 
                name="gig_filter" 
                value="a" 
                onChange={this.handleGigFilterChange} 
                checked={this.props.gigFilters.gigFilter == 'a'}
                />
              All
            </label>
          </div>
          <div className="panel-body">
            <ul>
              {this.getGigs().map((gig) =>
                <li key={gig.id} data-gig-id={gig.id}>
                  <img width="70" height="70" src={gig.spots().at(0).comedian().get('mugshot_url')} />
                  <a className="btn btn-lg btn-success" href={gig.bookingUrl()} target="_blank">Buy Tickets</a>
                  {gig.spots().at(0).comedian().get('name')}<br />
                  {moment(gig.get('time')*1000).format('Do MMM YYYY')}<br />
                </li>
              )}
            </ul>
          </div>
        </div>
      );

    } else {
      return (
        <div className="panel panel-default">
          <div className="panel-heading">
            <h4 className="panel-title">
              Click on a venue marker to display its gig list here.
            </h4>
          </div>
        </div>
      );
    }
  }
}
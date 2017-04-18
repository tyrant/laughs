class Overlay extends React.Component {

  constructor(props) {
    super(props);
  }


  // Fire up an event handler for changing tabs.
  componentDidMount() {
    $('#overlay a[data-toggle="tab"]').on('shown.bs.tab', (e) => {
      let newTab = $(e.target).attr('aria-controls');
      this.props.handleTabChange(newTab);
    });
  }

  render() {
    return (
      <div id="overlay" className="container" style={{display: this.props.showOverlay ? 'block' : 'none'}}>

        <ul className="nav nav-tabs" role="tablist">
          <li role="presentation" className={this.props.tab == 'faq' ? 'active' : ''}>
            <a href="#faq" aria-controls="faq" role="tab" data-toggle="tab">FAQs</a>
          </li>
          <li role="presentation" className={this.props.tab == 'email' ? 'active' : ''}>
            <a href="#email" aria-controls="email" role="tab" data-toggle="tab">Notify</a>
          </li>
          <li role="presentation" className={this.props.tab == 'gigs' ? 'active' : ''}>
            <a href="#gigs" aria-controls="gigs" role="tab" data-toggle="tab">Show</a>
          </li>
          <li role="presentation" className={this.props.tab == 'search' ? 'active' : ''}>
            <a href="#search" aria-controls="search" role="tab" data-toggle="tab">Find</a>
          </li>
        </ul>

        <div className="tab-content">

          <div role="tabpanel" className={this.props.tab == 'search' ? 'tab-pane active' : 'tab-pane'} id="search">
            <SearchForm 
              allComedians={this.props.allComedians} 
              selectedComedians={this.props.selectedComedians}
              startDate={this.props.startDate}
              endDate={this.props.endDate}
              handleSearchFormChange={this.props.handleSearchFormChange}
            />
          </div>

          <div role="tabpanel" className={this.props.tab == 'gigs' ? 'tab-pane active' : 'tab-pane'} id="gigs">
            <VenueInfo 
              currentVenue={this.props.currentVenue}
              gigFilters={this.props.gigFilters}
              handleGigFilterChange={this.props.handleGigFilterChange}
            />
          </div>

          <div role="tabpanel" className={this.props.tab == 'email' ? 'tab-pane active' : 'tab-pane'} id="email">
            <Notify 
              handlePlaceSearchSubmit={this.props.handlePlaceSearchSubmit}
              handleNotify={this.props.handleNotify}
              geodata={this.props.geodata}
              map={this.props.map}
              user={this.props.user}
              alerts={this.props.alerts}
              handleCreateAlert={this.props.handleCreateAlert}
              handleDestroyAlert={this.props.handleDestroyAlert}
              allComedians={this.props.allComedians} 
            />
          </div>

          <div role="tabpanel" className={this.props.tab == 'faq' ? 'tab-pane active' : 'tab-pane'} id="faq">
            <FAQs />
          </div>
        </div>
      </div>
    );
  }
}
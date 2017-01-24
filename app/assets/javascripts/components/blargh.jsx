

class Overlay extends React.Component {

  render() {
    return (<div id="overlay"></div>
    );
  }

}

class Banner extends React.Component {

  render() {
    return (
      <div id="banner">
        <span id="blurb">Find your favourite comics' gigs.</span>
      </div>
    );
  }
}


class Nav extends React.Component {

  render() {
    return (<div>
      <Overlay />
      <Banner />
    </div>);
  }
}


class Map extends React.Component {

  componentDidMount() {
    
  }

  render() {
    return (<div id="map"></div>);
  }
}



class Laughs extends React.Component {
  
  // We fire up Backbone, grab our URL params, grab our Venue JSON, and build a Backbone collection.
  constructor() {
    super();

  }

  render() {
    return (
      <div>
        <Nav />
        <Map />
      </div>
    );
  }
}

// ReactDOM.render(<Laughs />, document.getElementById('laughs'));
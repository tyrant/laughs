class SearchForm extends React.Component {

  constructor(props) {
    super(props);

    this.handleSearchFormChange = this.handleSearchFormChange.bind(this);
  }

  // Fire up the select2 and the two datetimepickers.
  componentDidMount() {

    // Fire up the select2 box.
    $('#comedians').select2({
      placeholder: "Find your favourite comics! Click or type here.",
      templateResult: (comic) => {
        if (comic.element) {
          return $('<span><img width="100" height="100" src="' + comic.element.attributes['data-src'].nodeValue + '">&nbsp;&nbsp;' + comic.text + '</span>');
        }
      },
      templateSelection: (comic) => {
        if (comic.element) {
          return $('<span>&nbsp;<img width="60" height="60" title="' + '" src="' + comic.element.attributes['data-src'].nodeValue + '"></span>');
        }
      }
    });

    // If the finest date granularity we have is months, it makes server caching so much easier.
    $('#start_date').datetimepicker({
      format:      'MMMM YYYY',
      defaultDate: this.props.startDate*1000,
    });

    $('#end_date').datetimepicker({ 
      format:      'MMMM YYYY',
      defaultDate: this.props.endDate*1000,
    });

    $('#start_date, #end_date').on('dp.change', () => { 
      this.handleSearchFormChange(); 
    });
    $('#comedians').on('change', () => { 
      this.handleSearchFormChange(); 
    });

    // Keeping the comedian search <ul> at the right height is
    // too dynamic and fiddly to implement with CSS alone. 
    // We want the comedian selection list to halt 10px above the page bottom no matter what.
    $('#comedians').on('select2:open', (e) => { 
      let comedianSelectBottom = 52 + parseInt($('.select2-container').css('height'));
      $('.select2-results__options').css('max-height', 'calc(100vh - ' + (comedianSelectBottom + 65) + 'px)');
    });
  }


  // Bit of munging. Change [[key, value], ...] to { key: value, ... }
  handleSearchFormChange() {
    const values = $('#filter').serializeArray();

    const startDate = _(values).find((v) => {
      return v.name == 'start_date';
    }).value;

    const endDate = _(values).find((v) => {
      return v.name == 'end_date';
    }).value;
    
    const comedians = _(values).chain().filter((v) => {
      return v.name == 'comedians[]';
    }).map((v) => {
      return v.value;
    }).value();

    // Reminder: these are still the raw form values! Just in object form,
    // not serialized array form.
    const betterValues = {
      startDate: startDate,
      endDate:   endDate,
      comedians: comedians,
    };

    // Timestamping date strings like "April 2019" returns a timestamp at the
    // start of the month. Let's bump it up to the month's end, and be inclusive.
    // And Safari chokes on moment('March 2018'), so add a 1 to the start.
    betterValues.endDate = moment('1 ' + betterValues.endDate).endOf('month').format('MMMM YYYY');

    this.props.handleSearchFormChange(betterValues);
  }

  render() {
    return (
      <form id="filter" method="get" data-remote="true" action="/venues">

        <div className="form-group">
          <select 
            name="comedians[]" 
            id="comedians" 
            className="form-control" 
            multiple="multiple" 
            defaultValue={this.props.selectedComedians.pluck('id')}
            style={{width: '100%'}}>
              {this.props.allComedians.map((comedian) =>
                <option 
                  key={comedian.id} 
                  value={comedian.id} 
                  data-src={comedian.get('mugshot_url')}
                  >
                  {comedian.get('name')}
                </option>
              )}
          </select>
        </div>

        <div className="row form-group date-filters">
          <div className="col-xs-6 start-container">
            <div className="form-group">
              <div className="input-group date" id="start_date">
                <span className="input-group-addon">
                  <span className="glyphicon glyphicon-calendar"></span>
                  From
                </span>
                <input type="text" name="start_date" className="form-control" />
              </div>
            </div>
          </div>

          <div className="col-xs-6 end-container">
            <div className="form-group">
              <div className="input-group date" id="end_date">
                <span className="input-group-addon">
                  <span className="glyphicon glyphicon-calendar"></span>
                  Until
                </span>
                <input type="text" name="end_date" className="form-control" />
              </div>
            </div>
          </div>
        </div>
      </form>
    );
  }
}
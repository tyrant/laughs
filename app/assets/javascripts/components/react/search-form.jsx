class SearchForm extends React.Component {

  constructor(props) {
    super(props);

    this.handleSearchFormChange = this.handleSearchFormChange.bind(this);
  }

  // Fire up the select2 and the two datetimepickers.
  componentDidMount() {

    // Fire up the select2 box.
    $('#comedians').select2({
      placeholder: 'Click or type to find gigs by...',
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

    $('#start_date').datetimepicker({
      format:      'DD MMM YYYY',
      defaultDate: this.props.startDate*1000,
    });

    $('#end_date').datetimepicker({ 
      format:      'DD MMM YYYY',
      defaultDate: this.props.endDate*1000,
    });

    $('#start_date, #end_date').on('dp.change', () => { 
      this.handleSearchFormChange(); 
    });
    $('#comedians').on('change', () => { 
      this.handleSearchFormChange(); 
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

    // Quick preprocessing: for both dates, turn 27 Jan 2017 into 2017-01-27.
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec'];

    const start = betterValues.startDate.split(' ');
    startMonth = _(months).indexOf(start[1]) + 1;
    startMonth = startMonth.toString().length == 1 ? '0' + startMonth : startMonth; // My kingdom for a padStart()
    betterStart = start[2] + '-' + startMonth + '-' + start[0];

    betterValues.startDate = betterStart;

    const end = betterValues.endDate.split(' ');
    endMonth = _(months).indexOf(end[1]) + 1;
    endMonth = endMonth.toString().length == 1 ? '0' + endMonth : endMonth; 
    betterEnd = end[2] + '-' + endMonth + '-' + end[0];
    betterValues.endDate = betterEnd;
    
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

        <div className="row">
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
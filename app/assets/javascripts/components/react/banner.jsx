class Banner extends React.Component {

  constructor(props) {
    super(props);

    this.handleMenuClick = this.handleMenuClick.bind(this);
    //this.initDeviseEvents = this.initDeviseEvents.bind(this);

    //this.initDeviseEvents();
  }


  handleMenuClick(e) {
    e.preventDefault();
    this.props.handleOverlayToggleClick();
  }

  
  // Can be the usual lot, 'logged_in', 'signed_up', 'logged_out'. Past tense;
  // called by ajax responses.
  componentDidUpdate() {

    $('#new_registration').off('ajax:error').on('ajax:error', (e, data) => {
      console.log('error', data.responseJSON)
      $('#new_registration .errors').html(data.responseJSON);
    });

    $('#new_session').off('ajax:error').on('ajax:error', (e, data) => {
      $('#new_session .errors').html(data.responseJSON.error);
    });

    $('#forgot_password_form').off('ajax:error').on('ajax:error', (e, data) => {
      console.log(data.responseJSON.errors, $('#forgot_password_form .errors').length)
      $('#forgot_password_form .errors').html(data.responseJSON.errors);
    });

    $('#new_registration').off('ajax:success').on('ajax:success', (e, data) => {
      this.props.handleDeviseEventCallbacks('signed_up', data);
      $('#signup').modal('hide');
    });

    $('#new_session').off('ajax:success').on('ajax:success', (e, data) => {
      this.props.handleDeviseEventCallbacks('logged_in', data);
      $('#login').modal('hide');
    })

    $('#forgot_password_form').off('ajax:success').on('ajax:success', (e, data) => {

    });

    $('#sign_out').on('click', () => {
      this.props.handleDeviseEventCallbacks('logged_out');
    });

    // Click on the login link.
    $('.devise-links #log_in_link').off('click').on('click', (e) => {
      e.preventDefault();

      // If the login modal isn't showing, show it.
      if (!$('#login').hasClass('in')) {
        $('#login').modal('show');
        $('#signup').modal('hide');
        $('#forgot_password').modal('hide');
      }
    });

    $('.devise-links #sign_up_link').off('click').on('click', (e) => {
      e.preventDefault();

      if (!$('#signup').hasClass('in')) {
        $('#signup').modal('show');
        $('#login').modal('hide');
        $('#forgot_password').modal('hide');
      }
    });

    $('.devise-links #forgot_password_link').off('click').on('click', e => {
      e.preventDefault();

      if (!$('#forgot_password').hasClass('in')) {
        $('#forgot_password').modal('show');
        $('#login').modal('hide');
        $('#signup').modal('hide');
      }
    });
  }


  render() {
    return (
      <div id="banner">
        <a id="home" className="btn btn-default" href="/">
          <i className="glyphicon glyphicon-home"></i>
        </a>
        <a id="toggle_overlay" className="btn btn-default" onClick={this.handleMenuClick}>
          <span className="glyphicon glyphicon-list" aria-hidden="true"></span>
        </a>
        {this.props.user ? (
          <span id="auth">
            You're {this.props.user.email}&nbsp;
            <a className="btn btn-default" id="sign_out" href="/users/sign_out" data-method="delete" data-remote="true">Log Out</a>
          </span>
        ) : (
          <span id="auth">
            <a className="btn btn-default" data-target="#signup" data-toggle="modal">
              Sign Up
            </a>
            <a className="btn btn-default" data-target="#login" data-toggle="modal">
              Log In
            </a>
          </span>
        )}

      </div>
    );
  }
}
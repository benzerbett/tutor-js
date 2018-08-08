import React from 'react';
import { Nav, NavDropdown, MenuItem } from 'react-bootstrap';
import { get } from 'lodash';
import { observer, inject } from 'mobx-react';
import { computed, observable, action } from 'mobx';
import classnames from 'classnames';
import UX from './../ux';

@inject('ux')
@observer
export default class UserActionsMenu extends React.Component {
  constructor(props) {
    super(props);
    this.props.ux.user.fetch()
  }

  static propTypes = {
    ux: React.PropTypes.instanceOf(UX).isRequired,
  };

  crsfToken = get(document.querySelector('meta[name=csrf-token]'), 'content')

  onLogoutClick = () => {
    this.refs.logoutForm.submit();
  }

  render() {
    if(this.props.ux.user.getUsername() != "") {
      return(
        <Nav pullRight={true} navbar={true}>
          <NavDropdown eventKey={1} id="navbar-dropdown" title={this.props.ux.user.getUsername()} ref="navDropDown">
            <MenuItem className="logout">
              <form
                ref="logoutForm"
                acceptCharset="UTF-8"
                action="/accounts/logout"
                className="-logout-form"
                method="post">
                <input type="hidden" name="_method" value="delete" />
                <input type="hidden" name="authenticity_token" value={this.crsfToken} />
                <input
                  type="submit"
                  aria-label="Log Out"
                  value="Log Out"
                  onClick={this.onLogoutClick} />
              </form>
            </MenuItem>
          </NavDropdown>
        </Nav>
      );
    }
    return (
      <p>Loading...</p>
    );
  }
}

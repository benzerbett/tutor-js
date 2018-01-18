import React from 'react';
import { inject, observer } from 'mobx-react';
import NavbarContext from './context';

@inject('navBar')
@observer
export default class PlugableNavBar extends React.Component {

  static propTypes = {
    navBar: React.PropTypes.instanceOf(NavbarContext).isRequired,
  };

  render() {
    const { left, right, center } = this.props.navBar;
    return (
      <nav className="tutor-top-navbar plugable">
        <div className="left-side-controls">
          {left.components}
        </div>
        <div className="center-control">
          {center.components}
        </div>
        <div className="right-side-controls">
          {right.components}
        </div>
      </nav>
    );
  }
}

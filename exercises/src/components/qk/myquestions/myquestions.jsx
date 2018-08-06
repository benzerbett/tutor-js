import React from 'react';
import QKQueryGroup from '../grouper/querygroup';
import { inject, observer } from 'mobx-react';
import UX from './../../../ux';

@inject('ux')
@observer
export default class QKMyQuestions extends React.Component {
  constructor(props) {
    super(props);
    this.props.ux.user.fetch()
  }

  static propTypes = {
    ux: React.PropTypes.instanceOf(UX).isRequired,
  };

  render() {
    if(this.props.ux.user.getUsername() != "") {
      console.log("Username not empty")
      return(
        <QKQueryGroup filter='author' value={this.props.ux.user.getUsername()} />
      );
    }
    console.log("Username empty")
    return (
      <p>Loading...</p>
    )
  }
}
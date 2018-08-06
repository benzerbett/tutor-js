import React from 'react';
// import Preview from '../../exercise/preview';
// import Controls from '../../search/controls';
// import { observer, inject } from 'mobx-react';
// import { action } from 'mobx';
// import UX from './../../../ux';
import QKQueryGrouper from './../grouper/querygroup';

class QKBoardSearch extends React.Component {
  render() {
    return(
      <QKQueryGrouper filter="tag" value={this.props.match.params.subject} />
    )
  }
}
export default QKBoardSearch;

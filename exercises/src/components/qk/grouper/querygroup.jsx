import React from 'react';
import Preview from '../../exercise/preview';
import { observer, inject } from 'mobx-react';
import { action } from 'mobx';
import UX from './../../../ux';

@inject('ux')
@observer
class QKQueryGroup extends React.Component {
  constructor(props) {
    super(props);
    this.props.ux.search.clauses[0].filter = this.props.filter;
    this.props.ux.search.clauses[0].value = this.props.value;
    this.props.ux.search.execute();
  }

  static propTypes = {
    ux: React.PropTypes.instanceOf(UX).isRequired,
    filter: React.PropTypes.string,
    value: React.PropTypes.string
  };

  get search() {
    return this.props.ux.search;
  }

  @action.bound onEdit(ev) {
    ev.preventDefault();
    this.props.history.push(ev.currentTarget.pathname);
  }

  render() {

    const { _clauses, exercises } = this.search;

    return (
      <div className="search">
        {exercises.map((e) => (
          <Preview key={e.uuid} exercise={e}>
            <a onClick={this.onEdit} href={`/exercise/${e.uid}`}>EDIT {e.uid}</a>
          </Preview>
        ))}
      </div>
    );
  }
}

export default QKQueryGroup;

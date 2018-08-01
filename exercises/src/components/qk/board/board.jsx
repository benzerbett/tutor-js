import React from 'react';
import Preview from '../../exercise/preview';
import Controls from '../../search/controls';
import { observer, inject } from 'mobx-react';
import { action } from 'mobx';
import UX from './../../../ux';

@inject('ux')
@observer
class QKBoardSearch extends React.Component {
  constructor(props) {
    super(props);
    this.props.ux.search.clauses[0].filter = 'tag';
    this.props.ux.search.clauses[0].value = this.props.match.params.subject;
    this.props.ux.search.execute();
  }

  static Controls = Controls;

  static propTypes = {
    ux: React.PropTypes.instanceOf(UX).isRequired,
    match: React.PropTypes.shape({
      params: React.PropTypes.shape({
        subject: React.PropTypes.string,
      }),
    }),
  };

  get search() {
    return this.props.ux.search;
  }

  @action.bound onEdit(ev) {
    ev.preventDefault();
    this.props.history.push(ev.currentTarget.pathname);
  }

  render() {

    const { clauses, exercises } = this.search;

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

export default QKBoardSearch;

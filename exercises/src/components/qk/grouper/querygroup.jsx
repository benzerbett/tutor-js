import React from 'react';
import Preview from '../../exercise/preview';
import Favorite from '../../../models/favorite';
import { observer, inject } from 'mobx-react';
import { action } from 'mobx';
import UX from './../../../ux';
import { Button } from 'reactstrap';
import lazyGetter from 'shared/helpers/lazy-getter';
import Query from '../../../models/query';


@inject('ux')
@observer
class QKQueryGroup extends React.Component {
  constructor(props) {
    super(props);
    this.query = new Query()
    this.query.perform(this.props.filter, this.props.value)
  }

  static propTypes = {
    ux: React.PropTypes.instanceOf(UX).isRequired,
    filter: React.PropTypes.string,
    value: React.PropTypes.string,
    showEdit: React.PropTypes.bool,
    showFave: React.PropTypes.bool,
  };

  // get search() {
  //   return this.props.ux.search;
  // }

  @action.bound onEdit(ev) {
    ev.preventDefault();
    this.props.history.push(ev.currentTarget.pathname);
  }

  @action.bound onFavorite(e) {
    var fav = new Favorite();
    fav.add(e.uid);
  }  

  render() {

    const { exercises } = this.query;

    return (
      <div className="search">
        {exercises.map((e) => (
          <Preview key={e.uuid} exercise={e}>
            {this.props.showEdit &&
              <a onClick={this.onEdit} href={`/exercise/${e.uid}`}>EDIT {e.uid}</a>
            }
            {this.props.showFave &&
              <Button onClick={() => this.onFavorite(e)}>FAVORITE</Button>
            }
          </Preview>
        ))}
      </div>
    );
  }
}

export default QKQueryGroup;

import PropTypes from 'prop-types';
import React from 'react';
import { find } from 'lodash';
import { ExercisePreview } from 'shared';
import { Link } from 'react-router-dom';
import { computed } from 'mobx';
import { observer } from 'mobx-react';
import { CornerRibbon } from 'shared';
import CurrentUser from '../../models/user';

export default
@observer
class ExerciseEditingPreview extends React.Component {

  static propTypes = {
    exercise: PropTypes.object.isRequired,
    displayEditLink: PropTypes.bool,
    showEdit: PropTypes.bool,
  }

  @computed get isAuthor() {
    const { exercise } = this.props;
    return Boolean(
      exercise.isNew || find(exercise.authors, { user_id: CurrentUser.id })
    );
  }

  render() {
    const { showEdit, exercise, ...previewProps } = this.props;

    return (
      <CornerRibbon
        shadow
        color="navy"
        position="topRight"
        label={
          [<div key="ro">READ ONLY</div>,<div key="n">Author: {exercise.authors.names().join(',')}</div>]
        }
        hidden={this.isAuthor}
      >
        <ExercisePreview
          className='exercise-editing-preview'
          isInteractive
          displayAllTags
          displayFeedback
          displayFormats
          displayNickname
          exercise={exercise}
          {...previewProps}
        >
          {showEdit && this.isAuthor && <Link className="btn" to={`/exercise/${exercise.uid}`}>EDIT</Link>}
        </ExercisePreview>
      </CornerRibbon>
    );
  }

};

import PropTypes from 'prop-types';
import React from 'react';
import Course from '../../models/course';
import { observer } from 'mobx-react';
import Events from './events-panel';
import EmptyCard from './empty-panel';

export default
@observer
class ThisWeekCard extends React.Component {

  static propTypes = {
    course: PropTypes.instanceOf(Course).isRequired,
  }

  render() {
    const { course, course: { studentTasks } } = this.props;
    const tasks = studentTasks.thisWeeksTasks;

    if (studentTasks.isPendingTaskLoading || !tasks.length) {
      return <EmptyCard course={course} message='No assignments this week' />;
    }

    return (
      <Events
        className="-this-week"
        course={course}
        events={tasks}
        startAt={studentTasks.startOfThisWeek}
        endAt={studentTasks.endOfThisWeek}
      />
    );
  }
};

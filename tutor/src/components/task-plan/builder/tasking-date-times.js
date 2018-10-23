import PropTypes from 'prop-types';
import React from 'react';
import BS from 'react-bootstrap';
import _ from 'underscore';
import moment from 'moment-timezone';

import { TimeStore } from '../../../flux/time';
import TimeHelper from '../../../helpers/time';
import Courses from '../../../models/courses-map';
import { TaskingActions, TaskingStore } from '../../../flux/tasking';

import Icon from '../../icon';
import DateTime from './date-time';

class TaskingDateTimes extends React.Component {
  static defaultProps = { bsSizes: { sm: 8, md: 9 } };

  static propTypes = {
    id:                  PropTypes.string.isRequired,
    courseId:            PropTypes.string.isRequired,
    termStart:           TimeHelper.PropTypes.moment,
    termEnd:             TimeHelper.PropTypes.moment,
    isEditable:          PropTypes.bool.isRequired,
    isVisibleToStudents: PropTypes.bool,
    taskingIdentifier:   PropTypes.string.isRequired,
    period:              PropTypes.object,
    bsSizes:             PropTypes.object,
  };

  getError = () => {
    if (!__guard__(this.refs != null ? this.refs.due : undefined, x => x.hasValidInputs()) || !__guard__(this.refs != null ? this.refs.open : undefined, x1 => x1.hasValidInputs())) { return false; }

    const { id, period } = this.props;

    if (TaskingStore.isTaskingValid(id, period != null ? period.serialize() : undefined)) { return false; }

    return _.first(TaskingStore.getTaskingErrors(id, period));
  };

  setDate = (type, value) => {
    const { id, period } = this.props;
    if (moment.isMoment(value)) { value = value.format(TimeHelper.ISO_DATE_FORMAT); }
    return TaskingActions.updateDate(id, period != null ? period.serialize() : undefined, type, value);
  };

  setDefaultTime = (timeChange) => {
    const { courseId, period } = this.props;
    const model = period ? period : Courses.get(courseId);
    _.assign(model, timeChange);
    model.save();
    return this.forceUpdate();
  };

  setTime = (type, value) => {
    const { id, period } = this.props;
    if (moment.isMoment(value)) { value = value.format(TimeHelper.ISO_DATE_FORMAT); }
    return TaskingActions.updateTime(id, period != null ? period.serialize() : undefined, type, value);
  };

  isSetting = () => {
    const { courseId } = this.props;
    return Courses.get(courseId).api.isPending;
  };

  render() {
    let extraError;
    let { isVisibleToStudents, isEditable, period, courseId, id, termStart, termEnd } = this.props;
    if (period) { period = period.serialize(); }
    const commonDateTimesProps = _.pick(this.props, 'required', 'currentLocale', 'taskingIdentifier');

    const model = period ? period : Courses.get(courseId);
    const { default_open_time, default_due_time } = model;

    const defaults = TaskingStore.getDefaultsForTasking(id, period);
    const { open_time, open_date, due_time, due_date } = TaskingStore._getTaskingFor(id, period);

    const now = TimeHelper.getMomentPreserveDate(TimeStore.getNow());
    const nowString = now.format(TimeHelper.ISO_DATE_FORMAT);

    const termStartString = termStart.format(TimeHelper.ISO_DATE_FORMAT);
    const termEndString   = termEnd.format(TimeHelper.ISO_DATE_FORMAT);

    const minOpensAt = termStart.isAfter(now) ? termStartString : nowString;
    const maxOpensAt = due_date || termEndString;

    const openDate = open_date || minOpensAt;

    const minDueAt = TaskingStore.isTaskOpened(id) ? minOpensAt : openDate;
    const maxDueAt = termEndString;

    const error = this.getError();

    if (error) { extraError = <BS.Col xs={12} md={6} mdOffset={6}>
      <p className="due-before-open">
        {error}
        <Icon type="exclamation-circle" />
      </p>
    </BS.Col>; }


    return (
      <BS.Col
        {...this.props.bsSizes}
        className="tasking-date-times"
        data-period-id={period ? period.id : 'all'}>
        <DateTime
          {...commonDateTimesProps}
          disabled={isVisibleToStudents || !isEditable}
          label="Open"
          ref="open"
          min={minOpensAt}
          max={maxOpensAt}
          setDate={_.partial(this.setDate, 'open')}
          setTime={_.partial(this.setTime, 'open')}
          value={openDate}
          defaultValue={open_time || defaults.open_time}
          defaultTime={default_open_time}
          setDefaultTime={this.setDefaultTime}
          timeLabel="default_open_time"
          isSetting={this.isSetting} />
        <DateTime
          {...commonDateTimesProps}
          disabled={!isEditable}
          label="Due"
          ref="due"
          min={minDueAt}
          max={maxDueAt}
          setDate={_.partial(this.setDate, 'due')}
          setTime={_.partial(this.setTime, 'due')}
          value={due_date}
          defaultValue={due_time || defaults.due_time}
          defaultTime={default_due_time}
          setDefaultTime={this.setDefaultTime}
          timeLabel="default_due_time"
          isSetting={this.isSetting} />
        {extraError}
      </BS.Col>
    );
  }
}

export default TaskingDateTimes;

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
import PropTypes from 'prop-types';
import React from 'react';
import { idType } from 'shared';
import { observer } from 'mobx-react';
import { observable, computed, action } from 'mobx';
import { Tooltip, OverlayTrigger } from 'react-bootstrap';
import { isNil, map } from 'lodash';
import classnames from 'classnames';
import Course from '../models/course';
import Courses from '../models/courses-map';
import PeriodHelper from '../helpers/period';
import Tabs from './tabs';

export default
@observer
class CoursePeriodsNav extends React.Component {

  static propTypes = {
    courseId: idType,
    course: PropTypes.instanceOf(Course),
    handleSelect: PropTypes.func,
    initialActive: PropTypes.number.isRequired,
    afterTabsItem: PropTypes.element,
  }

  static defaultProps = {
    initialActive: 0,
    sortedPeriods: [],
  }

  @observable tabIndex = this.props.initialActive;

  @computed get course() {
    return this.props.course || Courses.get(this.props.courseId);
  }

  @computed get sortedPeriods() {
    return this.course.periods.sorted;
  }

  @action.bound onTabSelection(tabIndex, ev) {
    if (this.tabIndex === tabIndex) { return; }

    const { handleSelect } = this.props;
    const period = this.sortedPeriods[tabIndex];
    if (isNil(period)) {
      ev.preventDefault();
      return;
    }
    this.tabIndex = tabIndex;
    if (handleSelect) { handleSelect(period, tabIndex); }
  }

  renderPeriod(period, key) {
    const className = classnames({ 'is-trouble': period.is_trouble });
    const tooltip =
      <Tooltip id={`course-periods-nav-tab-${key}`}>
        {period.name}
      </Tooltip>;

    return (
      <div className={className}>
        <OverlayTrigger placement="top" delayShow={1000} delayHide={0} overlay={tooltip}>
          <span className="tab-item-period-name">
            {period.name}
          </span>
        </OverlayTrigger>
      </div>
    );
  }

  render() {
    return (
      <Tabs
        ref="tabs"
        tabs={map(this.sortedPeriods, this.renderPeriod)}
        onSelect={this.onTabSelection}
      >
        {this.props.afterTabsItem}
      </Tabs>
    );
  }
};

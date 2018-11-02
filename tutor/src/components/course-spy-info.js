import React from 'react';
import { observer } from 'mobx-react';
import Course from '../models/course';
import { map, isEmpty, isString, toArray } from 'lodash';
import S from '../helpers/string';
import { SpyMode } from 'shared';

export default
@observer
class CourseSpyInfo extends React.Component {

  static propTypes = {
    course: React.PropTypes.instanceOf(Course),
  }

  render() {
    const { course } = this.props;

    if (!course || isEmpty(course.spy_info)) { return null; }

    return (
      <SpyMode.Content>
        <div className="course-spy-info">
          {map(course.spy_info, (v, k) => (
            <div key={k} className={k}>
              {S.titleize(k)}: {isString(v) ? v : S.toSentence(toArray(v))}
            </div>
          ))}
        </div>
      </SpyMode.Content>
    );
  }

};

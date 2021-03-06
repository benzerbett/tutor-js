import { TimeMock, React } from '../../helpers';
import { map, invokeMap } from 'lodash';
import moment from 'moment-timezone';
import Factory from '../../factories';
import EventsPanel from '../../../src/screens/student-dashboard/events-panel';
import chronokinesis from 'chronokinesis';

describe('EventsPanel', function() {
  let props;
  const now = new Date('2017-10-14T12:00:00.000Z');
  TimeMock.setTo(now);

  beforeEach(() => {
    const course = Factory.course();
    Factory.studentTasks({ course, now });
    props = {
      course,
      events: course.studentTasks.array,
    };
  });


  it('renders with events as named', function() {
    const wrapper = mount(<EventsPanel {...props} />);
    const renderedTitles = wrapper.find('Col[className="title"]').map(t => t.text());
    const mockTitles = map(props.events, 'title');
    expect(renderedTitles).toEqual(mockTitles);
    wrapper.unmount();
  });

});

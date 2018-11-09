import { SnapShot, Wrapper } from '../helpers/component-testing';
import Factory, { FactoryBot } from '../../factories';
import Courses from '../../../src/models/courses-map';
import Breadcrumbs from '../../../src/components/task-teacher-review/breadcrumbs';
import Router from '../../../src/helpers/router';
import EnzymeContext from '../helpers/enzyme-context';

jest.mock('../../../src/helpers/router');

describe('Task Teacher Review: Breadcrumbs', function() {
  let plan;
  let course;
  let props;

  beforeEach(() => {
    course = Factory.course();
    Courses.set(course.id, course);
    plan = course.taskPlans.withPlanId(1);
    plan.analytics.onApiRequestComplete({
      data: FactoryBot.create('TaskPlanStat', { course }),
    });
    Router.makePathname.mockReturnValue('/bread');
    props = {
      taskPlan: plan,
      scrollToStep: jest.fn(),
      stats: plan.analytics.stats[0],
      title: 'Title',
      courseId: '1',
    };
  });

  it('renders and matches snapshot', () => {
    const bc = shallow(<Breadcrumbs {...props} />);
    expect(SnapShot.create(
      <Wrapper _wrapped_component={Breadcrumbs} noReference={true} {...props} />).toJSON()
    ).toMatchSnapshot();
  });

  it('attempts to scroll when click', function() {
    const bc = mount(<Breadcrumbs {...props} />, EnzymeContext.build());
    bc.find('Breadcrumb').first().simulate('click');
    expect(props.scrollToStep).toHaveBeenCalled();
  });

});

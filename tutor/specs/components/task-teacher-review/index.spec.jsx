import { Factory, FactoryBot, EnzymeContext } from '../../helpers';
import planData from '../../../api/plans/1.json';
import TaskTeacherReview from '../../../src/components/task-teacher-review';
import Courses from '../../../src/models/courses-map';

describe('Task Teacher Review', () => {
  let plan;
  let course;
  let props;


  beforeEach(() => {
    course = Factory.course();
    Factory.taskPlans({ course });
    Courses.set(course.id, course);
    plan = course.taskPlans.array[0];
    plan.fetch = jest.fn(() => Promise.resolve());
    plan.onApiRequestComplete({ data: planData });
    plan.analytics.fetch = jest.fn();

    plan.analytics.onApiRequestComplete({
      data: FactoryBot.create('TaskPlanStat', { course }),
    });

    //course.periods[0].id = plan.analytics.stats[0].period_id;
    props = {
      params: {
        courseId: course.id,
        id: plan.id,
      },
    };
  });

  it('renders and matches snapshot', () => {
    const wrapper = mount(<TaskTeacherReview {...props} />, EnzymeContext.build());
    expect(wrapper).toHaveRendered('Stats');
    expect(wrapper).toHaveRendered('Review');
    expect(wrapper).toHaveRendered('Breadcrumbs');
    wrapper.unmount();
  });

});

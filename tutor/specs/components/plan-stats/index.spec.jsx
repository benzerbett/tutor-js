import { React, EnzymeContext, Factory } from '../../helpers';
import Stats from '../../../src/components/plan-stats';

describe('TaskPlan stats progress bar', function() {
  let props;
  let course;
  beforeEach(() => {
    course = Factory.course({ is_teacher: true });
    Factory.taskPlans({ course });
    props = {
      course: course,
      plan: course.taskPlans.array[0],
      handlePeriodSelect: jest.fn(),
    };
    // simulate has been loaded
    props.plan.analytics.api.requestCounts.read = 1;
  });

  it('deals with missing stats for a period', async () => {
    course.periods.push({ id: 99, name: 'testing', num_enrolled_students: 42 });
    const wrapper = mount(<Stats {...props} />, EnzymeContext.build());

    expect(await axe(wrapper.html())).toHaveNoViolations();
    wrapper.find('.nav-tabs li a').last().simulate('click');
    expect(wrapper.find('.text-not-started').text()).toEqual('0'); // not NaN
  });

});

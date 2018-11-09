import { Wrapper, SnapShot } from 'helpers';
import ExpiredPreviewWarning from '../../../src/components/onboarding/expired-preview-warning';
import CoursePreviewUX from '../../../src/models/course/onboarding/preview';
import EnzymeContext from '../helpers/enzyme-context';

describe('Expired Preview Warning', () => {

  let ux;
  beforeEach(() => {
    ux = new CoursePreviewUX({});
    ux.dismissNag = jest.fn();
  });

  it('renders and matches snapshot', () => {
    expect.snapshot(
      <Wrapper _wrapped_component={ExpiredPreviewWarning} ux={ux} />
    ).toMatchSnapshot();
  });

  it('dislays got it and dismisses on continue', async () => {
    const wrapper = shallow(<ExpiredPreviewWarning ux={ux} />);
    expect(await axe(wrapper.html())).toHaveNoViolations();
    wrapper.find('Button[variant="default"]').simulate('click');
    expect(wrapper.find('Body').render().text()).toContain('ready to create a real course');
    wrapper.find('Button[variant="primary"]').simulate('click');
    expect(ux.dismissNag).toHaveBeenCalled();
  });

  it('navigates on add', async () => {
    const context =  EnzymeContext.build();
    const wrapper = shallow(<ExpiredPreviewWarning ux={ux} />, context);
    expect(await axe(wrapper.html())).toHaveNoViolations();
    wrapper.find('Button[variant="primary"]').simulate('click');
    expect(context.context.router.history.push).toHaveBeenCalledWith('/dashboard');
  });

});

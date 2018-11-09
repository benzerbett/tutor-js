import { Wrapper, SnapShot } from 'helpers';
import PreviewOnlyWarning from '../../../src/components/onboarding/preview-only-warning';
import CoursePreviewUX from '../../../src/models/course/onboarding/preview';
import EnzymeContext from '../helpers/enzyme-context';

describe('Preview Only Warning', () => {

  let ux;

  beforeEach(() => {
    ux = new CoursePreviewUX({});
    Object.assign(ux, {
      hasViewedPublishWarning: jest.fn(),
    });
  });

  it('renders and matches snapshot', () => {
    expect.snapshot(
      <Wrapper _wrapped_component={PreviewOnlyWarning} ux={ux} />
    ).toMatchSnapshot();
  });

  it('dismisses on continue', async () => {
    const wrapper = shallow(<PreviewOnlyWarning ux={ux} />);
    expect(await axe(wrapper.html())).toHaveNoViolations();
    wrapper.find('Button[variant="default"]').simulate('click');
    expect(ux.hasViewedPublishWarning).toHaveBeenCalled();
  });

  it('navigates on add', async () => {
    const context =  EnzymeContext.build();
    const wrapper = shallow(<PreviewOnlyWarning ux={ux} />, context);
    expect(await axe(wrapper.html())).toHaveNoViolations();
    wrapper.find('Button[variant="primary"]').simulate('click');
    expect(context.context.router.history.push).toHaveBeenCalledWith('/dashboard');
  });

});

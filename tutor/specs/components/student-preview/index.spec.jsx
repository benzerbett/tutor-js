import { Wrapper, SnapShot } from 'helpers';
import StudentPreview from '../../../src/components/student-preview';
import Router from '../../../src/helpers/router';
import EnzymeContext from '../helpers/enzyme-context';
import { bootstrapCoursesList } from '../../courses-test-data';

jest.mock('../../../src/helpers/router');

describe('Student Preview Builder', () => {

  it('renders and matches snapshot', () => {
    bootstrapCoursesList();
    Router.currentParams.mockReturnValue({ courseId: '2' });
    Router.makePathname.mockImplementation(() => '/foo');
    expect(
      SnapShot.create(<Wrapper noReference _wrapped_component={StudentPreview} />
    ).toMatchSnapshot();
  });

  it('sets back button to dashboard if theres a courseId', () => {
    Router.currentParams.mockReturnValue({ courseId: '142' });
    const preview = shallow(<StudentPreview />, EnzymeContext.build());
    expect(preview.find('BackButton').props().fallbackLink).toEqual({
      to: 'dashboard',
      text: 'Back to Dashboard',
      params: { courseId: '142' },
    });
  });

});

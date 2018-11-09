import { React, SnapShot } from '../../helpers';
import SelectCourse from '../../../src/screens/new-course/select-course';
import BuilderUX from '../../../src/screens/new-course/ux';
import Offerings from '../../../src/models/course/offerings';

import OFFERINGS from '../../../api/offerings';
jest.mock('../../../src/models/user', () => ({
  isCollegeTeacher: true,
}));

describe('CreateCourse: Selecting course subject', function() {

  let ux;
  beforeEach(() => {
    ux = new BuilderUX();
    Offerings.onLoaded({ data: OFFERINGS });
  });

  it('it sets offering_id when clicked', async function() {
    const wrapper = mount(<SelectCourse ux={ux} />);
    expect(await axe(wrapper.html())).toHaveNoViolations();
    expect(ux.newCourse.offering_id).toEqual('');
    wrapper.find('.list-group-item').at(2).simulate('click');
    expect(ux.newCourse.offering_id).toEqual(OFFERINGS.items[2].id);
  });

  it('matches snapshot', function() {
    const component = SnapShot.create(<SelectCourse ux={ux} />);
    const tree = component.toJSON();
    expect(tree).toMatchSnapshot();
  });

});

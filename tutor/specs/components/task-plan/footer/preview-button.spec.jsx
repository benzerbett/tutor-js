import { SnapShot } from '../../../helpers';
import Preview from '../../../../src/components/task-plan/footer/preview-button';

describe('Task Plan Builder: Preview button', () => {

  let props;
  beforeEach(() => {
    props = {
      planType: 'reading',
      isWaiting: false,
      isNew: true,
      courseId: '1',
    };
  });

  it('renders when plan hw or reading', () => {
    const btn = shallow(<Preview {...props} />);
    expect(btn.html()).not.toBeNull();
    btn.setProps({ planType: 'external' });
    expect(btn.html()).toBeNull();
    btn.setProps({ planType: 'homework' });
    expect(btn.html()).not.toBeNull();
  });

  it('matches snapshot', function() {
    expect(
      SnapShot.create(<Preview {...props} />
    ).toMatchSnapshot();
  });

});

import MobxPropTypes from 'prop-types';
import React from 'react';

import { observer } from 'mobx-react';
import PaymentsPanel from '../payments/panel';
import { OnboardingNag, Body } from './onboarding-nag';

export default
@observer
class MakePayment extends React.Component {

  static propTypes = {
    ux: MobxPropTypes.observableObject.isRequired,
  }

  static className = 'make-payment';

  render() {
    const { ux } = this.props;

    return (
      <OnboardingNag className="make-payment">
        <PaymentsPanel onCancel={ux.onPayLater} onPaymentComplete={ux.onPaymentComplete} course={ux.course} />
      </OnboardingNag>
    );
  }

};

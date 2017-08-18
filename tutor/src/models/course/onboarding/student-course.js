import {
  computed, observable, action,
} from 'mobx';
import { get } from 'lodash';
import { UiSettings } from 'shared';
import BaseOnboarding from './base';
import Nags from '../../../components/onboarding/nags';
import Payments from '../../payments';
import User from '../../user';

const PAY_LATER_CHOICE  = 'PL';
const TRIAL_ACKNOWLEDGED = 'FTA';

export default class StudentCourseOnboarding extends BaseOnboarding {

  @observable displayPayment = false;
  @observable displayTrialActive = false;

  @computed get nagComponent() {
    if (User.terms_signatures_needed) { return null; }

    if (this.displayPayment) { return Nags.makePayment; }
    if (!Payments.config.is_enabled && this.course.does_cost){
      if (!UiSettings.get(TRIAL_ACKNOWLEDGED, this.course.id)) {
        return Nags.payDisabled;
      }
    } else if (this.course.needsPayment) {
      if (this.course.userStudentRecord.mustPayImmediately) {
        return Nags.freeTrialEnded;
      } else if (this.displayTrialActive) {
        return Nags.freeTrialActivated;
      } else if (!UiSettings.get(PAY_LATER_CHOICE, this.course.id)) {
        return Nags.payNowOrLater;
      }
    }

    return null;
  }

  @computed get isDisplaying() {
    return Boolean(this.nagComponent);
  }

  @computed get paymentIsPastDue() {
    return get(this.course, 'userStudentRecord.mustPayImmediately', false);
  }

  @action.bound
  acknowledgeTrial() {
    UiSettings.set(TRIAL_ACKNOWLEDGED, this.course.id, true);
  }

  @action.bound
  payNow() {
    this.displayPayment = true;
  }

  @action.bound
  onAccessCourse() {
    this.displayTrialActive = false;
  }

  @action.bound
  onPayLater() {
    UiSettings.set(PAY_LATER_CHOICE, this.course.id, true);
    this.displayTrialActive = true;
    this.displayPayment = false;
  }

  @action.bound
  onPaymentComplete() {
    this.displayPayment = false;
    // fetch tasks since they could not be fetched while student was in unpaid status
    this.course.studentTasks.fetch();
    this.course.userStudentRecord.markPaid();
  }

  mount() {
    super.mount();
    this.tourContext.otherModal = this;
  }

  close() {
    super.close();
    this.tourContext.otherModal = null;
  }

}

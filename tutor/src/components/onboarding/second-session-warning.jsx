import React from 'react';
import { Button } from 'react-bootstrap';
import { observer } from 'mobx-react';
import { action } from 'mobx';
import { OnboardingNag, GotItOnboardingNag, NagWarning, Body, Footer } from './onboarding-nag';
import User from '../../models/user';

@observer
export default class SecondSessionWarning extends GotItOnboardingNag {

  @action.bound
  onLoggedContinue(ev) {
    User.logEvent({ category: 'onboarding', code: 'like_preview_ask_later' });
    this.onContinue(ev);
  }

  @action.bound
  onLoggedAddCourse(ev) {
    User.logEvent({ category: 'onboarding', code: 'like_preview_yes' });
    this.onAddCourse(ev);
  }

  renderPrompt() {
    const { ux } = this.props;
    return (
      <OnboardingNag className="second-session-prompt">
        <Body>
          Ready to create your real course? It’s free for you and students will pay {ux.formattedStudentCost} per course per semester.
        </Body>
        <Footer>
          <Button bsStyle="primary" onClick={this.onLoggedAddCourse}>Create your course</Button>
          <Button onClick={this.onLoggedContinue}>Ask me later</Button>
        </Footer>
      </OnboardingNag>
    );
  }

}

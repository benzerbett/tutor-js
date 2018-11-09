import MobxPropTypes from 'prop-types';
import React from 'react';
import { Button } from 'react-bootstrap';
import { action, observable } from 'mobx';
import { observer } from 'mobx-react';
import Router from '../../helpers/router';

import { OnboardingNag, Heading, Body, Footer } from './nag-components';

export { OnboardingNag, Heading, Body, Footer };

export
@observer
 class GotItOnboardingNag extends React.Component {
  static propTypes = {
    ux: MobxPropTypes.observableObject.isRequired,
  }
  static contextTypes = {
    router: MobxPropTypes.object,
  }

  @observable noProblemo = false;

  @action.bound
  onAddCourse() {
    this.context.router.history.push(
      Router.makePathname('myCourses')
    );
  }

  @action.bound
  onContinue() {
    if (this.noProblemo) {
      this.props.ux.dismissNag();
    } else {
      this.noProblemo = true;
    }
  }

  renderNoProblem() {
    return (
      <OnboardingNag className="got-it">
        <Body>
          When you’re ready to create a real course, click “Create a course” on the top right of your dashboard.
        </Body>
        <Footer className="got-it">
          <Button bsStyle="primary" onClick={this.onContinue}>Got it</Button>
        </Footer>
      </OnboardingNag>
    );
  }

  render() {
    return this.noProblemo ? this.renderNoProblem() : this.renderPrompt();
  }
}

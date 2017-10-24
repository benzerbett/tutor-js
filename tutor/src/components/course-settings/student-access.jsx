import React from 'react';
import { observable, computed, action } from 'mobx';
import { observer } from 'mobx-react';
import { Button, Modal, PanelGroup, Panel } from 'react-bootstrap';
import Course from '../../models/course';
import Icon from '../icon';
import cn from 'classnames';
import CopyOnFocusInput from '../copy-on-focus-input';
import LMS from './lms-panel';

@observer
export default class StudentAccess extends React.PureComponent {

  static propTypes = {
    course: React.PropTypes.instanceOf(Course).isRequired,
  };

  @observable displayLinksWarning = false;

  renderCheckboxFor(lms) {
    const { course } = this.props;
    if (lms === course.is_lms_enabled) {
      return <Icon type="check" />;
    }
    return null;
  }

  renderDirectHeader() {
    const checked = false === this.props.course.is_lms_enabled;

    return (
      <div className={cn('choice', { checked })}>
        <div
          className="box"
          aria-label={checked ? 'Selected' : ''}
        />
        <div className="heading">
          <p className="title">
            Give students direct links
          </p>
          <p className="info">
            You will give students links to access OpenStax Tutor directly.
          </p>
        </div>
      </div>
    );
  }

  renderLMSHeader() {
    const checked = true === this.props.course.is_lms_enabled;

    return (
      <div className={cn('choice', { checked })}>
        <div
          className="box"
          aria-label={checked ? 'Selected' : ''}
        />
        <div className="heading">
          <p className="title">
            Access from paired LMS <i className="advanced">Advanced</i>
          </p>
          <p className="info">
            Integrate OpenStax Tutor with your Learning Management System (LMS) to send average course scores to your 
            LMS and enable single sign on.
          </p>
        </div>
      </div>
    );
  }

  @action.bound onSelectOption(isEnabled, ev, force = false) {
    const { course } = this.props;

    if (course.is_lms_enabled === isEnabled){ return; }

    if (course.is_lms_enabled) {
      if (!force) {
        this.displayLinksWarning = true;
        return;
      } else {
        this.displayLinksWarning = false;
      }
    }

    course.is_lms_enabled = isEnabled;

    course.save();
  }

  renderDirectLinks() {
    const { course } = this.props;

    return (
      <div className="student-access direct-links-only">
        <p>
          Give these links to your students in each section to enroll.
        </p>
        {course.periods.active.map(p => <CopyOnFocusInput key={p.id} label={p.name} value={p.enrollment_url} />)}
      </div>
    );
  }

  renderLMS() {
    const { course } = this.props;
    return course.is_lms_enabled ? <LMS course={course} /> : null;
  }

  @action.bound onHideLinkSwitch() {
    this.displayLinksWarning = false;
  }

  @action.bound forceLinksSwitch() {
    this.onSelectOption(true, true);
  }

  renderLinkSwitchWarning() {
    return (
      <Modal
        show={this.displayLinksWarning}
        onHide={this.onHideLinkSwitch}
        className="warn-before-links"
      >
        <Modal.Header closeButton={true}>
          <Modal.Title>Change access options?</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          If you opt to use direct links, you won't be able to use LMS integration
          features such as student single sign-on and scores sync.  Are you sure you
          want to change access options now?
        </Modal.Body>
        <Modal.Footer>
          <Button bsStyle="primary" onClick={this.forceLinksSwitch}>I'm sure</Button>
          <Button onClick={this.onHideLinkSwitch}>Cancel</Button>
        </Modal.Footer>
      </Modal>
    );
  }

  renderPreviewMessage() {
    return <p>Create a live course to view student access options.</p>;
  }

  render() {
    const { course } = this.props;
    let body = null;
    if (course.is_preview) {
      body = this.renderPreviewMessage();
    } else if (course.canOnlyUseEnrollmentLinks) {
      body = this.renderDirectLinks();
    } else if (course.canOnlyUseLMS) {
      body = <LMS course={course} />;
    }

    if (body) {
      return <div className="student-access">{body}</div>;
    }

    return (
      <div className="student-access">
        {this.renderLinkSwitchWarning()}
        <p>
          Choose how students access OpenStax Tutor. Access settings cannot be changed after students begin to enroll.
        </p>
        <a href="http://4tk3oi.axshare.com/salesforce_support_page_results.html" target="_blank">
          <Icon type="info-circle" /> Which option is right for my course?
        </a>
        <PanelGroup activeKey={course.is_lms_enabled} onSelect={this.onSelectOption} accordion>
          <Panel className="links" header={this.renderDirectHeader()} eventKey={false}>
            <p>Give these links to your students in each section to enroll.</p>
            {course.periods.active.map(p => <CopyOnFocusInput key={p.id} label={p.name} value={p.enrollment_url} />)}
          </Panel>
          <Panel className="lms" header={this.renderLMSHeader()} eventKey={true}>
            {this.renderLMS()}
          </Panel>
        </PanelGroup>
      </div>
    );
  }
}

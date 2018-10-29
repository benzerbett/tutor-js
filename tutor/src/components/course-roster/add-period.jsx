import PropTypes from 'prop-types';
import React from 'react';
import { observer } from 'mobx-react';
import { observable, action } from 'mobx';
import { Modal, Button } from 'react-bootstrap';
import Router from '../../helpers/router';
import { TutorInput } from '../tutor-input';
import { AsyncButton } from 'shared';
import CourseGroupingLabel from '../course-grouping-label';
import Icon from '../icon';
import Course from '../../models/course';
import Period from '../../models/course/period';
import classnames from 'classnames';

@observer
class AddPeriodField extends React.Component {

  static propTypes = {
    label: PropTypes.object.isRequired,
    name:  PropTypes.string.isRequired,
    onChange:  PropTypes.func.isRequired,
    validate: PropTypes.func.isRequired,
    autofocus: PropTypes.bool,
  }

  componentDidMount() {
    if (this.props.autofocus) { this.refs.input.focus(); }
  }

  render() {
    return (
      <TutorInput
        ref="input"
        label={this.props.label}
        default={''}
        required={true}
        onChange={this.props.onChange}
        validate={this.props.validate} />
    );
  }
}


export default
@observer
class AddPeriodLink extends React.Component {

  static propTypes = {
    course: PropTypes.instanceOf(Course).isRequired,
  }

  @observable showModal = Router.currentQuery().add;
  @observable period_name = '';
  @observable isValid = true;
  @observable isWaiting = false;

  @action.bound close() {
    this.showModal = false;
  }

  @action.bound open() {
    this.showModal = true;
  }

  @action.bound onPeriodChange(name) {
    this.period_name = name;
  }

  @action.bound validate(name) {
    this.isValid = !find(this.props.course.periods, { name });
  }

  @action.bound performUpdate() {
    this.isWaiting = true;
    const period = new Period({ course: this.props.course, name: this.period_name });
    period.create().then(() => {
      this.isWaiting = false;
      this.close();
    });
  }

  renderForm() {
    const { course } = this.props;
    return (
      <Modal
        show={this.showModal}
        onHide={this.close}
        className="settings-edit-period-modal">
        <Modal.Header closeButton={true}>
          <Modal.Title>
            Add <CourseGroupingLabel courseId={this.props.course.id} />
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className={classnames({ 'is-invalid-form': !this.isValid })}>
          <AddPeriodField
            label={<span><CourseGroupingLabel courseId={course.id} /> Name</span>}
            name="period-name"
            onChange={this.onPeriodChange}
            validate={this.validate}
            autofocus={true} />
        </Modal.Body>
        <Modal.Footer>
          <AsyncButton
            className="-edit-period-confirm"
            onClick={this.performUpdate}
            isWaiting={this.isWaiting}
            waitingText="Adding..."
            disabled={!this.isValid}
          >
            Add
          </AsyncButton>
        </Modal.Footer>
      </Modal>
    );
  }

  render() {
    return (
      <Button onClick={this.open} variant="link" className="control add-period">
        <Icon type="plus" />
        Add <CourseGroupingLabel courseId={this.props.course.id} />
        {this.renderForm()}
      </Button>
    );
  }

};

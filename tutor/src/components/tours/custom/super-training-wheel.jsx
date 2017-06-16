import React                  from 'react';

import { action }             from 'mobx';

import { defaultsDeep, omit } from 'lodash';
import classnames             from 'classnames';

import CenteredNoHoleWheel    from './centered-no-hole-wheel';
import { bindClickHandler }   from './common';

export default class SuperTrainingWheel extends React.PureComponent {

  className = 'super-training-wheel'

  @action.bound
  handleClick = bindClickHandler.call(this, {close: this.triggerNext.bind(this)});

  triggerNext() {
    this.props.step.joyrideRef.next();
  }

  render () {
    const step = this.props.step;
    const buttons = (
      this.props.step.joyrideRef &&
      this.props.step.joyrideRef.props.steps.length < 3
    )? { primary: 'Continue' } : {};
    const className = classnames(this.className,  this.props.className);

    step.text = this.props.children;
    step.isFixed = true;

    defaultsDeep(step.style, this.props.style);
    defaultsDeep(buttons, this.props.buttons);

    return (
      <CenteredNoHoleWheel
        {...omit(this.props, 'style', 'buttons')}
        showOverlay={true}
        className={className}
        step={step}
        buttons={buttons}
        onClick={this.handleClick}
      />
    );
  }
}

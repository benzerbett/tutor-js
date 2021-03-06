import PropTypes from 'prop-types';
import React from 'react';
import ReactDOM from 'react-dom';
import omit from 'lodash/omit';
import classnames from 'classnames';

import { typesetMath } from '../helpers/mathjax';
import { wrapFrames } from '../helpers/html-videos';

export default class extends React.Component {
  static defaultProps = {
    block: false,
    shouldExcludeFrame(frame) { return false; },
  };

  static displayName = 'ArbitraryHtmlAndMath';

  static propTypes = {
    className: PropTypes.string,
    html: PropTypes.string,
    block: PropTypes.bool.isRequired,
    processHtmlAndMath: PropTypes.func,
  };

  componentDidMount() { return this.updateDOMNode(); }

  // rendering uses dangerouslySetInnerHTML and then runs MathJax,
  // Both of which React can't optimize like it's normal render operations
  // Accordingly, only update if any of our props have actually changed
  shouldComponentUpdate(nextProps, nextState) {
    for (let propName in nextProps) {
      const value = nextProps[propName];
      if (this.props[propName] !== value) { return true; }
    }
    return false;
  }

  componentDidUpdate() { return this.updateDOMNode(); }

  getHTMLFromProp = () => {
    const { html } = this.props;
    if (html) {
      return { __html: html };
    }
  };

  // Perform manipulation on HTML contained inside the components node.
  updateDOMNode = () => {
    // External links should open in a new window
    const root = ReactDOM.findDOMNode(this);
    const links = root.querySelectorAll('a');
    for (let link of links) {
      if (__guard__(link.getAttribute('href'), x => x[0]) !== '#') { link.setAttribute('target', '_blank'); }
    }
    (typeof this.props.processHtmlAndMath === 'function' ? this.props.processHtmlAndMath(root) : undefined) || typesetMath(root);
    return wrapFrames(root, this.props.shouldExcludeFrame);
  };

  render() {
    const { className, block } = this.props;

    const classes = classnames('openstax-has-html', className);

    const otherProps = omit(this.props, 'className', 'block', 'html', 'shouldExcludeFrame', 'processHtmlAndMath');

    if (block) {
      return (
        <div
          {...otherProps}
          className={classes}
          dangerouslySetInnerHTML={this.getHTMLFromProp()} />
      );
    } else {
      return (
        <span
          {...otherProps}
          className={classes}
          dangerouslySetInnerHTML={this.getHTMLFromProp()} />
      );
    }
  }
}

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
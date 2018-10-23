import PropTypes from 'prop-types';
import React from 'react';
import { Link } from 'react-router-dom';
import concat from 'lodash/concat';
import BS from 'react-bootstrap';

import { filterProps } from '../helpers/react';
const filterPropsBase = filterProps;

const BUTTON_LINK_PROPS = [
  'alt',
  'title',
  'active',
  'type',
  'block',
  'componentClass',
  'disabled',
];

const BUTTON_LINK_PREFIXES = [
  'bs',
];

filterProps = function(props, options = {}) {
  options.props = concat(BUTTON_LINK_PROPS, options.props || []);
  options.prefixes = concat(BUTTON_LINK_PREFIXES, options.prefixes || []);
  return filterPropsBase(props, options);
};

const make = function(router, name = 'OpenStax') {
  return class extends React.Component {
    static displayName = `${name}ButtonLink`;

    static propTypes = {
      to:     PropTypes.string.isRequired,
      params: PropTypes.object,
      query:  PropTypes.object,
    };

    static contextTypes = {
      router: PropTypes.object,
    };

    UNSAFE_componentWillReceiveProps(nextProps) {
      return this.setState({ fullPathname: this.makeFullPathname(nextProps) });
    }

    makeFullPathname = (props) => {
      if (props == null) { ((((((({ props } = this))))))); }
      const { to, params, query } = props;
      return router.makePathname(to, params, { query });
    };

    goToPathname = (clickEvent) => {
      clickEvent.preventDefault();
      return this.context.router.transitionTo(this.state.fullPathname);
    };

    state = { fullPathname: this.makeFullPathname() };

    render() {
      const { fullPathname } = this.state;

      return (
        <BS.Button
          href={fullPathname}
          onClick={this.goToPathname}
          {...filterProps(this.props)} />
      );
    }
  };
};

export { make, filterProps };

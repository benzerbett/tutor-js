import PropTypes from 'prop-types';
import React from 'react';
import cn from 'classnames';
import OXFancyLoader from './ox-fancy-loader';

export default function LoadingScreen({ className, message = 'Loading…' }) {
  return (
    <div className={cn('loading-screen-animation', className)}>
      <OXFancyLoader isLoading={true} />
      <h3>{message}</h3>
    </div>
  );
}

LoadingScreen.props = {
  className: PropTypes.string,
  message: PropTypes.string,
};

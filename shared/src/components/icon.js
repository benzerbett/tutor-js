import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { uniqueId, defaults } from 'lodash';
import { Tooltip, OverlayTrigger, Button } from 'react-bootstrap';
import { React, PropTypes, cn } from '../helpers/react';
import { library } from '@fortawesome/fontawesome-svg-core';


// Don't attempt to remove the duplication by using variable substition without testing ;)
// It seems like With webpack 4 it will either:
//   * require all icons in the build
//   * fail to load required icons
const Icons = {
  // regular
  'calendar':             require('@fortawesome/free-regular-svg-icons/faCalendar.js'),
  'check-square':         require('@fortawesome/free-regular-svg-icons/faCheckSquare'),
  'circle':               require('@fortawesome/free-regular-svg-icons/faCircle'),
  'clock':                require('@fortawesome/free-regular-svg-icons/faClock'),
  'comments':             require('@fortawesome/free-regular-svg-icons/faComments'),
  'envelope':             require('@fortawesome/free-regular-svg-icons/faEnvelope'),
  'square':               require('@fortawesome/free-regular-svg-icons/faSquare'),

  // solid
  'angle-down':           require('@fortawesome/free-solid-svg-icons/faAngleDown'),
  'arrow-down':           require('@fortawesome/free-solid-svg-icons/faArrowDown'),
  'arrow-left':           require('@fortawesome/free-solid-svg-icons/faArrowLeft'),
  'arrow-right':          require('@fortawesome/free-solid-svg-icons/faArrowRight'),
  'arrow-up':             require('@fortawesome/free-solid-svg-icons/faArrowUp'),
  'ban':                  require('@fortawesome/free-solid-svg-icons/faBan'),
  'bars':                 require('@fortawesome/free-solid-svg-icons/faBars'),
  'bullhorn':             require('@fortawesome/free-solid-svg-icons/faBullhorn'),
  'caret-left':           require('@fortawesome/free-solid-svg-icons/faCaretLeft'),
  'caret-right':          require('@fortawesome/free-solid-svg-icons/faCaretRight'),
  'check-circle':         require('@fortawesome/free-solid-svg-icons/faCheckCircle'),
  'check-square-solid':   require('@fortawesome/free-solid-svg-icons/faCheckSquare'),
  'cheveron-left':        require('@fortawesome/free-solid-svg-icons/faChevronLeft'),
  'chevron-down':         require('@fortawesome/free-solid-svg-icons/faChevronDown'),
  'chevron-right':        require('@fortawesome/free-solid-svg-icons/faChevronRight'),
  'chevron-left':         require('@fortawesome/free-solid-svg-icons/faChevronLeft'),
  'chevron-up':           require('@fortawesome/free-solid-svg-icons/faChevronUp'),
  'clock-solid':          require('@fortawesome/free-solid-svg-icons/faClock'),
  'comment-solid':        require('@fortawesome/free-solid-svg-icons/faComment'),
  'comments-solid':       require('@fortawesome/free-solid-svg-icons/faComments'),
  'download':             require('@fortawesome/free-solid-svg-icons/faDownload'),
  'edit':                 require('@fortawesome/free-solid-svg-icons/faEdit'),
  'exclamation-circle':   require('@fortawesome/free-solid-svg-icons/faExclamationCircle'),
  'exclamation-triangle': require('@fortawesome/free-solid-svg-icons/faExclamationTriangle'),
  'external-link-alt':    require('@fortawesome/free-solid-svg-icons/faExternalLinkAlt'),
  'eye':                  require('@fortawesome/free-solid-svg-icons/faEye'),
  'eye-slash':            require('@fortawesome/free-solid-svg-icons/faEyeSlash'),
  'ghost':                require('@fortawesome/free-solid-svg-icons/faGhost'),
  'hand-paper':           require('@fortawesome/free-solid-svg-icons/faHandPaper'),
  'info-circle':          require('@fortawesome/free-solid-svg-icons/faInfoCircle'),
  'paper-plane':          require('@fortawesome/free-solid-svg-icons/faPaperPlane'),
  'pencil-alt':           require('@fortawesome/free-solid-svg-icons/faPencilAlt'),
  'plus-square':          require('@fortawesome/free-solid-svg-icons/faPlusSquare'),
  'print':                require('@fortawesome/free-solid-svg-icons/faPrint'),
  'question-circle':      require('@fortawesome/free-solid-svg-icons/faQuestionCircle'),
  'save':                 require('@fortawesome/free-solid-svg-icons/faSave'),
  'sort':                 require('@fortawesome/free-solid-svg-icons/faSort'),
  'sort-down':            require('@fortawesome/free-solid-svg-icons/faSortDown'),
  'sort-up':              require('@fortawesome/free-solid-svg-icons/faSortUp'),
  'spinner':              require('@fortawesome/free-solid-svg-icons/faSpinner'),
  'th':                   require('@fortawesome/free-solid-svg-icons/faTh'),
  'thumbs-up':            require('@fortawesome/free-solid-svg-icons/faThumbsUp'),
  'times':                require('@fortawesome/free-solid-svg-icons/faTimes'),
  'times-circle':         require('@fortawesome/free-solid-svg-icons/faTimesCircle'),
  'trash-alt':            require('@fortawesome/free-solid-svg-icons/faTrashAlt'),
  'user-plus':            require('@fortawesome/free-solid-svg-icons/faUserPlus'),
  'video':                require('@fortawesome/free-solid-svg-icons/faVideo'),
};

Object.keys(Icons).forEach(k => {
  const icon = Icons[k];
  if (icon) {
    library.add(icon.definition);
    Icons[k] = icon.definition;
  } else {
    // eslint-disable-next-line no-console
    console.warn(`Icon ${k} was not imported correctly`);
  }
});

export { Icons };

const defaultTooltipProps = {
  placement: 'top',
  trigger: ['hover', 'focus'],
};

export default
class Icon extends React.Component {

  static propTypes = {
    type: PropTypes.oneOf(Object.keys(Icons)).isRequired,
    spin: PropTypes.bool,
    className: PropTypes.string,
    onClick: PropTypes.func,
    onNavbar: PropTypes.bool,
    tooltipProps: PropTypes.object,
    buttonProps: PropTypes.object,
    variant: PropTypes.string,
    btnVariant: PropTypes.string,
    tooltip: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.element,
    ]),
  };

  static defaultProps = {
    buttonProps: {},
    tooltipProps: defaultTooltipProps,
  };

  uniqueId = uniqueId('icon-tooltip-')

  render() {
    const {
      onClick, buttonProps, tooltipProps, btnVariant,
      type, className, tooltip, onNavbar, variant,
      ...props
    } = this.props;

    //invariant(Icons[type], `${type} has not been imported`);

    let iconEl = (
      <FontAwesomeIcon
        data-variant={variant}
        className={cn('ox-icon', type, className)}
        icon={Icons[type]}
        {...props}
      />
    );

    if (onClick || btnVariant) {
      iconEl = (
        <Button
          variant={btnVariant || 'plain'}
          className={cn(type, className)}
          onClick={onClick}
          {...buttonProps}
        >{iconEl}</Button>
      );
    }

    if (!tooltip) {
      return iconEl;
    }

    const tooltipEl = React.isValidElement(tooltip) ?
      tooltip : (
        <Tooltip
          id={this.uniqueId}
          className={cn('ox-icon-tt', { 'on-navbar': onNavbar })}
          {...defaults(tooltipProps, defaultTooltipProps)}
        >
          {this.props.tooltip}
        </Tooltip>
      );


    return (
      <OverlayTrigger {...tooltipProps} overlay={tooltipEl}>
        {iconEl}
      </OverlayTrigger>
    );

  }

}

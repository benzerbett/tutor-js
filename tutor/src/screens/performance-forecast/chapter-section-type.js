import PropTypes from 'prop-types';
import React from 'react';

export default PropTypes.shape({
  title:                    PropTypes.string,
  children:                 PropTypes.array,
  chapter_section:          PropTypes.array,
  clue:                     PropTypes.object,
  student_count:            PropTypes.number,
  questions_answered_count: PropTypes.number,
});

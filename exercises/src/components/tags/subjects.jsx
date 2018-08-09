import React from 'react';
import Exercise from '../../models/exercises/exercise';
import SingleDropdown from './single-dropdown';

const TYPE = 'subject';
const TYPES = {
  'biology': 'Biology',
  'chemistry': 'Chemistry',
  'economics': 'Economics',
  'government': 'Government',
  'history': 'History',
  'math': 'Math',
  'physics': 'Physics',
  'sociology': 'Sociology',
};

function SubjectTag(props) {
  return (
    <SingleDropdown
      {...props} label="Subject" type={TYPE} choices={TYPES}
    />
  );
}

SubjectTag.propTypes = {
  exercise: React.PropTypes.instanceOf(Exercise).isRequired,
};

export default SubjectTag;

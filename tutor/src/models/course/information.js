import String from '../../helpers/string';

const SUBJECTS = {
  PHYSICS:    'Physics',
  BIOLOGY:    'Biology',
  SOCIOLOGY:  'Sociology',
  ECONOMICS:  'Economics',
  MACRO_ECONOMICS: 'Macroeconomics',
  MICRO_ECONOMICS: 'Microeconomics',
  ANATOMY_PHYSIOLOGY: 'Anatomy & Physiology',
};


// NOTE:
//  * The 'biology' and 'physics' codes are deprecated, but are retained for older courses that may have them
//  * These codes must be kept in sync with the styles in variables/book-content.less
export default {
  physics: {
    title:      'Physics',
    subject:    SUBJECTS.PHYSICS,
    bp_doc:     'college-physics',
  },
  hs_physics: {
    title:      'High School Physics',
    subject:    SUBJECTS.PHYSICS,
  },
  college_physics: {
    title:      'College Physics',
    subject:    SUBJECTS.PHYSICS,
    bp_doc:     'college-physics',
  },
  biology: {
    title:      'Biology',
    subject:    SUBJECTS.BIOLOGY,
    bp_doc:     'biology',
  },
  ap_biology: {
    title:      'Biology for AP® Courses',
    subject:    SUBJECTS.BIOLOGY,
  },
  concepts_biology: {
    title:      'Concepts of Biology',
    subject:    SUBJECTS.BIOLOGY,
  },
  college_biology: {
    title:      'College Biology',
    subject:    SUBJECTS.BIOLOGY,
    bp_doc:     'biology',
  },
  principles_economics: {
    title:      'Principles of Economics',
    subject:    SUBJECTS.ECONOMICS,
  },
  macro_economics: {
    title:      'Macroeconomics',
    subject:    SUBJECTS.MACRO_ECONOMICS,
  },
  micro_economics: {
    title:      'Microeconomics',
    subject:    SUBJECTS.MICRO_ECONOMICS,
  },
  intro_sociology: {
    title:      'Introduction to Sociology',
    subject:    SUBJECTS.SOCIOLOGY,
    bp_doc:     'sociology',
  },
  anatomy_physiology: {
    title:      'Anatomy & Physiology',
    subject:    SUBJECTS.ANATOMY_PHYSIOLOGY,
  },

  bestPracticesDocumentURLFor(code) {
    return this[code] && this[code].bp_doc ?
      `https://s3-us-west-2.amazonaws.com/openstax-assets/oscms-prodcms/media/documents/oxt-${this[code].bp_doc}-best-practices.pdf` : '';
  },

  forAppearanceCode(code) {
    return this[code] || { title: String.titleize(code), subject: '' };
  },

  gettingStartedGuide: {
    teacher: 'https://d3bxy9euw4e147.cloudfront.net/oscms-prodcms/media/documents/openstax_tutor_instructor_getting_started_guide_2018.pdf',
    student: 'https://d3bxy9euw4e147.cloudfront.net/oscms-prodcms/media/documents/openstax_tutor_student_getting_started_guide.pdf',
  },

};

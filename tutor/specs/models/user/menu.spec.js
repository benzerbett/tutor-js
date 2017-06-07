import Courses from '../../../src/models/courses-map';
import UserMenu from '../../../src/models/user/menu';
import User from '../../../src/models/user';
jest.mock('../../../src/models/user', () => ({
  isConfirmedFaculty: true,
}));

import { bootstrapCoursesList, STUDENT_COURSE_ONE_MODEL, TEACHER_COURSE_TWO_MODEL, TEACHER_AND_STUDENT_COURSE_THREE_MODEL, MASTER_COURSES_LIST } from '../../courses-test-data';

const STUDENT_MENU = [
  {
    name: 'myCourses',
    options: { separator: 'after' },
    label: 'My courses',
  },
  {
    name: 'dashboard',
    params: { courseId: '1' },
    label: 'Dashboard',
  },
  {
    name: 'browseBook',
    params: { courseId: '1' },
    label: 'Browse the book',
  },
  {
    name: 'viewPerformanceGuide',
    params: { courseId: '1' },
    label: 'Performance forecast',
  },
  {
    name: 'changeStudentId',
    params: { courseId: '1' },
    label: 'Change student ID',
    options: { separator: 'after' },
  },
];

const TEACHER_MENU = [
  {
    name: 'myCourses',
    options: { separator: 'after' },
    label: 'My courses',
  },
  {
    name: 'dashboard',
    label: 'Dashboard',
    params: { courseId: '2' },
  },
  {
    name: 'browseBook',
    params: { courseId: '2' },
    label: 'Browse the book',
  },
  {
    name: 'viewPerformanceGuide',
    params: { courseId: '2' },
    label: 'Performance forecast',
  },
  {
    name: 'viewQuestionsLibrary',
    params: { courseId: '2' },
    label: 'Question library',
  },
  {
    name: 'viewScores',
    label: 'Student scores',
    params: { courseId: '2' },
  },
  {
    name: 'courseSettings',
    label: 'Course settings and roster',
    params: { courseId: '2' },
  },
  {
    name: 'createNewCourse',
    options: { separator: 'before' },
    params: { courseId: '2' },
    label: 'Create a course',
  },
  {
    name: 'createNewCourse',
    options: { key: 'clone-course', separator: 'after' },
    params: { sourceId: '2' },
    label: 'Copy this course',
  },
];

const TEACHER_NO_COURSE_MENU = [
  {
    name: 'createNewCourse',
    options: { separator: 'both' },
    label: 'Create a course',
  },
];

describe('Current User Store', function() {

  beforeEach(function() {
    bootstrapCoursesList();
  });

  afterEach(function() {
    Courses.clear();
  });

  it('computes help URL', () => {
    expect(UserMenu.helpURL).toContain('Tutor');
    expect(UserMenu.helpLinkForCourseId(1)).toContain('Tutor');
    Courses.get(1).is_concept_coach = true;
    expect(UserMenu.helpURL).toContain('Coach');
    expect(UserMenu.helpLinkForCourseId(1)).toContain('Coach');
  });

  it('should return expected menu routes for courses', function() {
    User.isConfirmedFaculty = false;
    expect(UserMenu.getRoutes('1')).to.deep.equal(STUDENT_MENU);
    User.isConfirmedFaculty = true;
    expect(UserMenu.getRoutes('2')).to.deep.equal(TEACHER_MENU);
    Courses.clear();
    expect(UserMenu.getRoutes()).to.deep.equal(TEACHER_NO_COURSE_MENU);
  });
});

import CourseUX from '../../../src/models/course/basic-ux';

import { bootstrapCoursesList } from '../../courses-test-data';

describe('Basic Course UX Model', () => {
  let ux;
  beforeEach(() => {
    const courses = bootstrapCoursesList();
    ux = new CourseUX(courses.get(1));
  });

  it('#dataProps', () => {
    expect(ux.dataProps).toEqual({
      'data-appearance': 'testing',
      'data-book-title': 'Testing',
      'data-title': 'Local Test Course One',
    });
  });

  it('#formattedStudentCost', () => {
    expect(ux.formattedStudentCost).toEqual('$10');
  });
});

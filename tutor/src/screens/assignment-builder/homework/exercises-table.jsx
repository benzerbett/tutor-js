import PropTypes from 'prop-types';
import React from 'react';
import { each, every, map, times } from 'lodash';
import { TaskPlanStore } from '../../../flux/task-plan';
import Course from '../../../models/course';
import fluxToMobx from '../../../helpers/flux-to-mobx';
import { observer } from 'mobx-react';
import { ArrayOrMobxType } from 'shared/helpers/react';
import { ArbitraryHtmlAndMath } from 'shared';
import ChapterSection from '../../../components/chapter-section';
import TourRegion from '../../../components/tours/region';

@observer
class ExerciseTable extends React.Component {
  //  mixins: [LoadingExercises]
  static propTypes = {
    course:     PropTypes.instanceOf(Course).isRequired,
    exercises:  ArrayOrMobxType.isRequired,
    planId:     PropTypes.string.isRequired,
  };

  renderExerciseRow = (exercise, index) => {
    const { section, lo, tagString } = exercise.tags.importantInfo;

    let content = document.createElement('span');
    content.innerHTML = exercise.content.questions[0].stem_html;
    each(content.getElementsByTagName('img'), function(img) {
      if (img.nextSibling) {
        img.remove();
      } else {
        if (img.parentElement) img.parentElement.remove();
      }
    });

    content = content.innerHTML;

    return (
      <tr key={`exercise-row-${index}`}>
        <td className="exercise-number">
          {index + 1}
        </td>
        <td>
          <ChapterSection section={section} />
        </td>
        <td>
          <ArbitraryHtmlAndMath block={false} html={content} />
        </td>
        <td className="ellipses">
          {lo}
        </td>
        <td className="ellipses">
          {tagString.join(' / ')}
        </td>
      </tr>
    );
  };

  renderTutorRow(exercises, index) {
    return (
      <tr key={`exercise-row-tutor-${index}`}>
        <td className="exercise-number">
          {exercises.length + index + 1}
        </td>
        <td>
          -
        </td>
        <td>
          Tutor Selection
        </td>
        <td>
          -
        </td>
        <td>
          -
        </td>
      </tr>
    );
  }

  render() {

    const { course, exercises } = this.props;
    const tutorSelection = TaskPlanStore.getTutorSelections(this.props.planId);

    return (
      <TourRegion
        tag="table"
        delay={4000}
        className="exercise-table"
        id="add-homework-review-sections"
        courseId={course.id}
      >
        <thead>
          <tr>
            <td />
            <td />
            <td>
              Problem Question
            </td>
            <td>
              Learning Objective
            </td>
            <td>
              Details
            </td>
          </tr>
        </thead>
        <tbody>
          {map(exercises, (exercise, index) => this.renderExerciseRow(exercise, index))}
          {times(tutorSelection, index => this.renderTutorRow(exercises, index))}
        </tbody>
      </TourRegion>
    );
  }
}


export default ExerciseTable;

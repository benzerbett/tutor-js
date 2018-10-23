import { expect, _ } from 'shared/specs/helpers';
import times from 'lodash/times';
import cloneDeep from 'lodash/cloneDeep';

import TaskHelper from 'helpers/task';
import UiSettings from 'model/ui-settings';

const TASK_PRACTICE_TYPES = ['practice', 'chapter_practice', 'page_practice', 'practice_worst_topics'];
const TASK_HOMEWORK_TYPE = 'homework';
const TASK_READING_TYPE = 'reading';
const TASK_EVENT_TYPE = 'event';
const TASK_CONCEPT_COACH_TYPE = 'concept_coach';

const EXERCISE_DEFAULT_GROUP = 'default';
const EXERCISE_CORE_GROUP = 'core';
const EXERCISE_SPACED_PRACTICE_GROUP = 'spaced practice';
const EXERCISE_PERSONALIZED_GROUP = 'personalized';

const QUESTION_MULTI_TYPES = ['multiple-choice', 'true-false', 'fill-in-the-blank'];
const QUESTION_FREE_RESPONSE_TYPE = 'free-response';

const EXERCISE_STEP_BASE = {
  id: '',
  task_id: '1',
  type: 'exercise',
  group: EXERCISE_CORE_GROUP,
  is_completed: false,

  content: {
    questions: [{
      formats: ['multiple-choice'],
    }],
  },
};

const TASK_BASE = {
  id: '1',
  type: '',
};

const pickRandom = types => types[_.random(0, types.length - 1)];

const makeTwoStep = function() {
  const question = {
    formats:
      ['free-response'],
  };

  question.formats.push(pickRandom(QUESTION_MULTI_TYPES));
  return {
    content: {
      questions:
        [question],
    },
  };
};

const makeTask = function(taskType = 'reading', stepLength = 1, stepModifications = {}) {
  const task = cloneDeep(TASK_BASE);
  task.type = taskType;

  task.steps = times(stepLength, () => cloneDeep(EXERCISE_STEP_BASE));

  _.each(stepModifications, (mod, stepIndex) => _.extend(task.steps[stepIndex], { id: String(stepIndex) }, mod));

  return task;
};

describe('Task Helper', function() {

  afterEach(() => UiSettings._reset());

  describe('will add intro step for first two-step', function() {

    const numberOfSteps = 10;
    const twoStepPositions = [1, 4, 6, 7, 8];
    let stepModifications = {};

    const testForTwoStep = function(task, steps) {
      expect(steps.length).to.equal(task.steps.length + 2);
      expect(steps[1].type).to.equal('two-step-intro');
      return expect(UiSettings.get(`two-step-info-${task.type}`).stepId).to.equal('1');
    };

    beforeEach(() => stepModifications = _.object(twoStepPositions, times(twoStepPositions.length, makeTwoStep)));

    describe('for reading task', function() {
      it('does not intro if two-step is not yet available', function() {
        const readingTask = makeTask(TASK_READING_TYPE, numberOfSteps, stepModifications);
        const steps = TaskHelper.mapSteps(readingTask);

        expect(steps.length).to.equal(readingTask.steps.length + 1);
        expect(_.where(steps, { isAvailable: true }).length).to.equal(1);
        return undefined;
      });

      return it('only if two-step is completed or next upcoming step', function() {

        stepModifications[0] =
          { is_completed: true };

        const readingTask = makeTask(TASK_READING_TYPE, numberOfSteps, stepModifications);
        const steps = TaskHelper.mapSteps(readingTask);

        testForTwoStep(readingTask, steps);
        expect(_.where(steps, { isAvailable: true }).length).to.equal(3);
        return undefined;
      });
    });

    it('for homework task', function() {

      const homeworkTask = makeTask(TASK_HOMEWORK_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(homeworkTask);

      testForTwoStep(homeworkTask, steps);
      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(homeworkTask.steps.length + 2);
      return undefined;
    });

    it('for coach task', function() {

      const coachTask = makeTask(TASK_CONCEPT_COACH_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(coachTask);

      testForTwoStep(coachTask, steps);
      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(coachTask.steps.length + 2);
      return undefined;
    });

    it('for practice task', function() {

      const practiceTask = makeTask(pickRandom(TASK_PRACTICE_TYPES), numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(practiceTask);

      testForTwoStep(practiceTask, steps);
      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(practiceTask.steps.length + 2);
      return undefined;
    });

    return it('does not place intro card if placed elsewhere', function() {
      UiSettings.initialize({
        'two-step-info-homework': {
          stepId: 'test',
          taskId: 'test',
        },
      });

      const homeworkTask = makeTask(TASK_HOMEWORK_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(homeworkTask);
      expect(steps.length).to.equal(homeworkTask.steps.length + 1);
      return undefined;
    });
  });

  describe('will add review/intro step for first review/spaced practice in the right order', function() {

    const numberOfSteps = 20;
    let stepModifications = {};
    const stepModification = {
      group: EXERCISE_SPACED_PRACTICE_GROUP,
      labels: [ 'review' ],
    };

    const testReviewAndSpacedPractice = function(task, steps) {
      expect(steps.length).to.equal(task.steps.length + 3);
      expect(steps[12].type).to.equal('individual-review-intro');
      return expect(steps[13].type).to.equal('spaced-practice-intro');
    };

    beforeEach(() =>
      stepModifications = {
        12: stepModification,
        13: stepModification,
        14: stepModification,
      }
    );

    it('for reading task, creates but does not save placement', function() {

      const readingTask = makeTask(TASK_READING_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(readingTask);

      testReviewAndSpacedPractice(readingTask, steps);
      expect(UiSettings.get('spaced-practice-info-reading')).to.be.not.ok;
      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(1);
      return undefined;
    });

    it('for homework task', function() {

      const homeworkTask = makeTask(TASK_HOMEWORK_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(homeworkTask);

      testReviewAndSpacedPractice(homeworkTask, steps);
      expect(UiSettings.get('spaced-practice-info-homework').stepId).to.equal('12');
      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(homeworkTask.steps.length + 3);
      return undefined;
    });

    it('for coach task', function() {

      const coachTask = makeTask(TASK_CONCEPT_COACH_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(coachTask);

      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(coachTask.steps.length + 2);
      return undefined;
    });

    it('for practice task, does not introduce', function() {

      const practiceTask = makeTask(pickRandom(TASK_PRACTICE_TYPES), numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(practiceTask);

      expect(steps.length).to.equal(practiceTask.steps.length + 1);
      return undefined;
    });

    return it('does not place spaced practice intro card if placed elsewhere', function() {
      UiSettings.initialize({
        'spaced-practice-info-homework': {
          stepId: 'test',
          taskId: 'test',
        },
      });

      const homeworkTask = makeTask(TASK_HOMEWORK_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(homeworkTask);
      expect(steps.length).to.equal(homeworkTask.steps.length + 2);
      return undefined;
    });
  });


  return describe('will add intro step for first personalized', function() {

    const numberOfSteps = 20;
    let stepModifications = {};
    const stepModification =
      { group: EXERCISE_PERSONALIZED_GROUP };

    const testForPersonalized = function(task, steps) {
      expect(steps.length).to.equal(task.steps.length + 2);
      expect(steps[12].type).to.equal('personalized-intro');
      return expect(UiSettings.get(`personalized-info-${task.type}`).stepId).to.equal('12');
    };

    beforeEach(() =>
      stepModifications = {
        12: stepModification,
        13: stepModification,
        14: stepModification,
      }
    );

    describe('for reading task', function() {
      it('does not intro if personalized is not yet available', function() {
        const readingTask = makeTask(TASK_READING_TYPE, numberOfSteps, stepModifications);
        const steps = TaskHelper.mapSteps(readingTask);

        expect(steps.length).to.equal(readingTask.steps.length + 1);
        expect(_.where(steps, { isAvailable: true }).length).to.equal(1);
        return undefined;
      });

      return it('only if personalized is completed or next upcoming step', function() {

        _.each(_.range(0, 12), function(stepIndex) {
          if (stepModifications[stepIndex] == null) { stepModifications[stepIndex] = {}; }
          return stepModifications[stepIndex].is_completed = true;
        });

        const readingTask = makeTask(TASK_READING_TYPE, numberOfSteps, stepModifications);
        const steps = TaskHelper.mapSteps(readingTask);

        testForPersonalized(readingTask, steps);
        expect(_.where(steps, { isAvailable: true }).length).to.equal(14);
        return undefined;
      });
    });

    it('for homework task', function() {

      const homeworkTask = makeTask(TASK_HOMEWORK_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(homeworkTask);

      testForPersonalized(homeworkTask, steps);
      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(homeworkTask.steps.length + 2);
      return undefined;
    });

    it('for coach task', function() {

      const coachTask = makeTask(TASK_CONCEPT_COACH_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(coachTask);

      testForPersonalized(coachTask, steps);
      expect(_.where(steps, { isAvailable: true }).length)
        .to.equal(coachTask.steps.length + 2);
      return undefined;
    });

    it('for practice task, does not introduce', function() {

      const practiceTask = makeTask(pickRandom(TASK_PRACTICE_TYPES), numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(practiceTask);

      expect(steps.length).to.equal(practiceTask.steps.length + 1);
      return undefined;
    });

    return it('does not place intro card if placed elsewhere', function() {
      UiSettings.initialize({
        'personalized-info-homework': {
          stepId: 'test',
          taskId: 'test',
        },
      });

      const homeworkTask = makeTask(TASK_HOMEWORK_TYPE, numberOfSteps, stepModifications);
      const steps = TaskHelper.mapSteps(homeworkTask);
      expect(steps.length).to.equal(homeworkTask.steps.length + 1);
      return undefined;
    });
  });
});

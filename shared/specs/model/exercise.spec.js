import Factories from '../factories';

describe('Exercise Model', () => {
  let exercise;
  beforeEach(() => exercise = Factories.exercise({}));

  it('can be created from fixture and serialized', () => {
    expect(exercise.serialize()).toMatchObject({
      version: expect.any(Number),
    });
  });


  it('can move questions up/down', () => {
    exercise = Factories.exercise({ multipart: true });
    const second = exercise.questions[1];
    exercise.moveQuestion(second, -1);
    expect(exercise.questions[0]).toBe(second);
    expect(() =>
      exercise.moveQuestion(second, -1)
    ).toThrow();

    const nextToLast = exercise.questions[exercise.questions.length - 2];
    exercise.moveQuestion(nextToLast, 1);
    expect(exercise.questions[exercise.questions.length - 1]).toBe(nextToLast);
    expect(() =>
      exercise.moveQuestion(nextToLast, 1)
    ).toThrow();
  });

  it('gets author names', () => {
    expect(exercise.authors.names()).toEqual(exercise.authors.map(a=>a.name));
  });

  it('calculates validity', () => {
    expect(exercise.validity.valid).toBe(true);
    const dok = exercise.tags.withType('dok');
    dok.value = '';
    expect(exercise.validity.valid).toBe(false);
    dok.value = '3';
    expect(exercise.validity.valid).toBe(true);
    exercise.questions[0].stem_html = '';
    expect(exercise.questions[0].validity.valid).toBe(false);
    expect(exercise.validity.valid).toBe(false);
  });

  it('toggles multipart', () => {
    expect(exercise.isMultiPart).toBe(false);
    exercise.toggleMultiPart();
    expect(exercise.isMultiPart).toBe(true);
  });

  it('tests isPublishable', () => {
    expect(exercise.isPublishable).toBe(true);
    exercise.published_at = new Date();
    expect(exercise.isPublishable).toBe(false);
  });
});

import { expect } from 'chai';
import _ from 'underscore';

import Helpers from '../src/helpers/task';

describe('TaskHelpers', function() {

  it('returns false if task is not late', function() {
    const lateness = Helpers.getLateness({
      due_at: '2015-07-22T12:00:00.000Z',
      last_worked_at: '2015-07-21T17:09:44.012Z',
    });
    expect( lateness.is_late ).to.be.false;
    expect( lateness.how_late ).to.be.null;
    return undefined;
  });

  it('calculates time differences if task is late by a day', function() {
    const lateness = Helpers.getLateness({
      due_at: '2015-07-22T12:00:00.000Z',
      last_worked_at: '2015-07-23T12:00:00.000Z',
    });
    expect( lateness.is_late ).to.be.true;
    expect( lateness.how_late ).to.equal('a day');
    return undefined;
  });

  return it('calculates time differences if task is late by a few minutes', function() {
    const lateness = Helpers.getLateness({
      due_at: '2015-07-22T12:00:00.000Z',
      last_worked_at: '2015-07-22T12:30:20.000Z',
    });
    expect( lateness.is_late ).to.be.true;
    expect( lateness.how_late ).to.equal('30 minutes');
    return undefined;
  });
});

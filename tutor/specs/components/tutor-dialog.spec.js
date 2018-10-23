import { React, Testing } from './helpers/component-testing';
import { Promise } from 'es6-promise';

import TutorDialog from '../../src/components/tutor-dialog';

describe('TutorDialog', () =>

  it('can be shown multiple times', function() {
    const promises = [1, 2, 3].map((i) =>
      new Promise( function(resolve) {
        const title = `dialog title ${i}`;
        const body  = `dialog body ${i}`;
        TutorDialog.show({ title, body }).then( () => resolve());
        const dialogs = document.body.querySelectorAll('.tutor-dialog');
        expect(dialogs).to.have.length(1);
        const el = document.body.querySelector('.tutor-dialog');
        expect(el.querySelector('.modal-title').textContent).to.equal(title);
        expect(el.querySelector('.modal-body').textContent).to.equal(body);
        return Testing.actions.click(document.body.querySelector('.tutor-dialog button.ok'));
      }));
    return Promise.all(promises);
  })
);

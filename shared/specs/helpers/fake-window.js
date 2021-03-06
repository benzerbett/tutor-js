import defer from 'lodash/defer';
import merge from 'lodash/merge';
import isFunction from 'lodash/isFunction';
import cloneDeep from 'lodash/cloneDeep';
import { JSDOM } from 'jsdom';

const EmptyFn = () => undefined;

const defaults = {
  clearInterval: EmptyFn,
  setInterval() { return jest.fn( () => Math.random()); },

  document: {
    hidden: false,
  },

  pageYOffset: 0,
  pageXOffset: 0,

  scroll(x, y) {
    this.pageXOffset = x;
    return this.pageYOffset = y;
  },

  requestAnimationFrame(cb) { return defer(cb); },
  querySelector: jest.fn(qs => global.document.querySelector(qs)),

  location: {
    pathname: '/',
    search: '',
  },

  innerHeight: 1024,
  innerWidth:  768,
};

class FakeWindow {

  constructor(attrs = {}) {
    merge(this, attrs, defaults);
    for (let name in this) {
      // jest.fn(@, name) was causing some weird stack trace on the above methods...
      const method = this[name];
      if (isFunction(method)) {
        this[name] = jest.fn(method);
      }
    }
    this.localStorage = {
      getItem: jest.fn(() => '[]'),
      setItem: jest.fn(() => null),
    };
    this.document.body = global.document.body;
    this.history =
      { pushState: jest.fn() };
    this.open = jest.fn( () => {
      this.openedDOM = new JSDOM('<!DOCTYPE html><body></body>');
      return this.openedDOM.window;
    });
    this.screen = {
      height: 1024,
      width:  768,
    };
    this.addEventListener = jest.fn();
    this.removeEventListener = jest.fn();
    this.location.href = 'http://localhost:3001/dashboard';
    this.location.reload = jest.fn();
  }
}


export default FakeWindow;

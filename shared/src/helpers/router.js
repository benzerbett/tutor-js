import qs from 'qs';
import map from 'lodash/map';
import last from 'lodash/last';
import omit from 'lodash/omit';
import pick from 'lodash/pick';
import partial from 'lodash/partial';
import merge from 'lodash/merge';
import remove from 'lodash/remove';
import extend from 'lodash/extend';
import memoize from 'lodash/memoize';
import compact from 'lodash/compact';
import isEmpty from 'lodash/isEmpty';
import forEach from 'lodash/forEach';
import mapValues from 'lodash/mapValues';
import cloneDeep from 'lodash/cloneDeep';
import pathToRegexp from 'path-to-regexp';


import { matchPath } from 'react-router-dom';


class OXRouter {

  constructor() {
    this.currentMatch = this.currentMatch.bind(this);
    this.currentParams = this.currentParams.bind(this);
    this.currentState = this.currentState.bind(this);
    this.makePathname = this.makePathname.bind(this);
    this.isActive = this.isActive.bind(this);
    this.getRenderableRoutes = this.getRenderableRoutes.bind(this);
  }

  setRoutes(routes) {
    const { routeSettings, renderers } = OXRouter.separateRendersFromRoutes(routes);
    const mappedRoutes = mapRoutes(routeSettings);

    this.getRenderers = () => renderers;
    this.getRoutes = () => routeSettings;
    return this.getRoutesMap = () => mappedRoutes;
  }

  currentMatch(path = window.location.pathname) {
    return cloneDeep(findRoutePathMemoed(path, this.getRoutesMap()));
  }

  currentQuery(options = {}) {
    return qs.parse((options.window || window).location.search.slice(1));
  }

  currentParams(options = {}) {
    const params = __guard__(this.currentMatch( (options.window || window).location.pathname), x => x.params) || {};
    return mapValues(params, function(value) { if (value === 'undefined') { return undefined; } else { return value; }  });
  }


  currentState(options = {}) {
    return {
      params: this.currentParams(options),
      query:  this.currentQuery(options),
    };
  }

  makePathname(name, params, options = {}) {
    const route = __guardMethod__(this.getRoutesMap()[name], 'toPath', o => o.toPath(params));

    if (!isEmpty(options.query)) {
      return `${route}?${qs.stringify(options.query)}`;
    } else {
      return route;
    }
  }

  isActive(name, params, options = {}) {
    const route = this.getRoutesMap()[name];
    return route && ((options.window || window).location.pathname === this.makePathname(name, params, options));
  }

  getRenderableRoutes() {
    const renderers = this.getRenderers();
    const routes = this.getRoutes();
    const routesMap = this.getRoutesMap();

    return traverseRoutes(routes, function(route) {
      if (renderers[route.name] == null) { return null; }

      route.render = renderers[route.name]();
      route.getParamsForPath = partial(getParamsByPath, routesMap[route.name].path);
      return route;
    });
  }
}

OXRouter.separateRendersFromRoutes = function(routes) {
  const renderers = {};

  const routeSettings = traverseRoutes(routes, function(route) {
    if (route.renderer != null) { renderers[route.name] = route.renderer; }
    return pick(route, 'path', 'name', 'routes', 'settings');
  });

  return { renderers, routeSettings };
};


var getParamsByPath = function(path, pathname = window.location.pathname) {
  const match = matchPath(pathname, { path });
  return (match != null ? match.params : undefined);
};

var traverseRoutes = function(routes, transformRoute) {
  const modifiedRoutes = compact(map(routes, function(route) {
    if (route.routes != null) {
      route = transformRoute(route);
      if (!route) { return; }

      const nestedRoutes = traverseRoutes(route.routes, transformRoute);
      if (!isEmpty(nestedRoutes)) { route.routes = nestedRoutes; }
      return route;
    } else {
      return transformRoute(route);
    }
  }));
  remove(modifiedRoutes, isEmpty);
  return modifiedRoutes;
};


var mapRoutes = function(routes, paths = {}, parentPath = {}) {

  forEach(routes, function(route) {
    paths[route.name] = buildPathMemoed(route, parentPath);
    if (route.routes != null) { return mapRoutes(route.routes, paths, paths[route.name]); }
  });

  return paths;
};

const buildPath = function(route, parent) {
  const path = omit(cloneDeep(parent), 'toPath', 'name');
  extend(
    path,
    pick(route, 'settings', 'name'),
    {
      path: parent.path ? `${parent.path}/${route.path}` : route.path,
    },
  );
  path.toPath = pathToRegexp.compile(path.path);
  return path;
};

var buildPathMemoed = memoize(buildPath);

const findRoutePath = function(pathname, mappedPaths) {
  const matchedEntrys = [];

  const matchedPaths = compact(map(mappedPaths, function(path) {
    const match = matchPath(pathname, { path: path.path });
    if (match) { matchedEntrys.push(path); }
    return match;
  }));

  if (matchedPaths.length) {
    // return deepest matches
    return extend(
      {},
      last(matchedPaths),
      {
        entry: last(matchedEntrys),
      },
    );
  } else {
    return null;
  }
};


var findRoutePathMemoed = memoize(findRoutePath);

export default OXRouter;

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
function __guardMethod__(obj, methodName, transform) {
  if (typeof obj !== 'undefined' && obj !== null && typeof obj[methodName] === 'function') {
    return transform(obj, methodName);
  } else {
    return undefined;
  }
}
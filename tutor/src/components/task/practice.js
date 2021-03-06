import PropTypes from 'prop-types';
import React from 'react';
import { Task } from './index';
import Loading from 'shared/components/loading-animation';
import Router from '../../helpers/router';
import LoadableItem from '../loadable-item';
import { TaskActions, TaskStore } from '../../flux/task';
import { CoursePracticeActions, CoursePracticeStore } from '../../flux/practice';
import InvalidPage from '../invalid-page';

class PracticeTask extends React.Component {
  static propTypes = {
    courseId: PropTypes.string.isRequired,
    taskId:   PropTypes.string.isRequired,
  };

  render() {
    return (
      <LoadableItem
        id={this.props.taskId}
        loadingMessage="Loading Practice…"
        store={TaskStore}
        actions={TaskActions}
        renderItem={() => <Task id={this.props.taskId} />} />
    );
  }
}

class LoadPractice extends React.Component {
  static contextTypes = {
    router: PropTypes.object,
  };

  static propTypes = {
    courseId: PropTypes.string.isRequired,
  };

  componentDidMount() {
    CoursePracticeStore.on(`loaded.${this.props.courseId}`, this.onPracticeLoad);
    return CoursePracticeActions.create({ courseId: this.props.courseId, query: Router.currentQuery() });
  }

  componentWillUnmount() {
    return CoursePracticeStore.off(`loaded.${this.props.courseId}`, this.onPracticeLoad);
  }

  onPracticeLoad = (taskId) => {
    return this.context.router.history.push(
      Router.makePathname('practiceTopics', { taskId, courseId: this.props.courseId })
    );
  };

  render() {
    return (
      <Loading message="Retrieving practice exercises…" />
    );
  }
}

class PracticeTaskShell extends React.Component {
  render() {
    const { params, query } = Router.currentState();
    if (query.page_ids || query.worst) {
      return <LoadPractice courseId={params.courseId} sectionIds={query.page_ids} />;
    } else if (params.taskId) {
      return <PracticeTask courseId={params.courseId} taskId={params.taskId} />;
    } else {
      return <InvalidPage />;
    }
  }
}

export default PracticeTaskShell;

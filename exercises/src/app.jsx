import React from 'react';
import { Grid, Navbar, Nav, NavItem, } from 'react-bootstrap';
import { BrowserRouter, Route } from 'react-router-dom';
import { Provider, observer } from 'mobx-react';
import { action } from 'mobx';
import UX from './ux';
import Search from './components/search';
import Exercise from './components/exercise';
import Preview from './components/preview';
import QK from './components/qk';
import QKControls from './components/qk/controls/controls';
import QKQuestionRoute from './components/qk/questionroute/QuestionRoute';
import QKNewQuestion from './components/qk/newquestion/NewQuestion';
import QKHelp from './components/qk/help/Help';
import QKProfile from './components/qk/profile/Profile';
import QKSubjectPicker from './components/qk/subjectpicker/SubjectPicker';
import QKBoardSearch from './components/qk/board/board';
import UserActionsMenu from './components/user-actions-menu';
import ExercisesControls from './exercises-controls';

export default class App extends React.Component {
  ux = new UX();

  @action.bound
  onNav(ev) {
    ev.preventDefault();
    this.router.history.push(ev.currentTarget.pathname);
  }
  

  render() {
    const {
      ux,
      props: {
        data: { user }
      }
    } = this;
    
    return (
      <Provider ux={ux}>
        <BrowserRouter ref={br => (this.router = br)}>
          <Grid fluid className={"exercises"}>
            <Route path="/search" component={ExercisesControls} />
            <Route path="/exercise" component={ExercisesControls} />
            <Route path="/preview" component={ExercisesControls} />
            <Route path="/qk" component={QKControls} />
            <div className={"exercises-body"}>
              <Route path="/search" component={Search} />
              <Route path="/exercise/:uid" component={Exercise} />
              <Route path="/preview/:uid" component={Preview} />
              <Route path="/qk/home" component={QK} />
              <Route path="/qk/questions" component={QKQuestionRoute} />
              <Route path="/qk/new-question" component={QKNewQuestion} />
              <Route path="/qk/help" component={QKHelp} />
              <Route path='/qk/subjects' component={QKSubjectPicker}/>
              <Route path='/qk/subject/:subject' component={QKBoardSearch} />
              <Route path="/qk/profile" component={QKProfile} />
            </div>
          </Grid>
        </BrowserRouter>
      </Provider>
    );
  }
}

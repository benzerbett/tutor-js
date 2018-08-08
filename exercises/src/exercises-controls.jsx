import React from 'react';
import { Grid, Navbar, Nav, NavItem, } from 'react-bootstrap';
import { BrowserRouter, Route } from 'react-router-dom';
import { Provider, observer, inject } from 'mobx-react';
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

export default class ExercisesControls extends React.Component {

  @action.bound
  onNav(ev) {
    ev.preventDefault();
    this.router.history.push(ev.currentTarget.pathname);
  }

  render() {
    return(
      <Navbar fixedTop>
        <Navbar.Header>
          <Navbar.Brand>
            <a href="#home">OX Exercises</a>
          </Navbar.Brand>
        </Navbar.Header>
        <Nav className="exercise-navbar-controls">
          <NavItem onClick={this.onNav} href="/search">
            Search
          </NavItem>
          <NavItem onClick={this.onNav} href="/exercise/new">
            New
          </NavItem>
          <Route path="/search" component={Search.Controls} />
          <Route path="/exercise/:uid" component={Exercise.Controls} />
          <Route path="/preview/:uid" component={Preview.Controls} />
        </Nav>
        <UserActionsMenu />
      </Navbar>
    )
  }
}
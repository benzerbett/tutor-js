import React from "react";
import { Grid, Navbar, Nav, NavItem } from "react-bootstrap";
import { BrowserRouter, Route } from "react-router-dom";
import { Provider, observer } from "mobx-react";
import { action } from "mobx";
import UX from "./ux";
import Search from "./components/search";
import Exercise from "./components/exercise";
import Preview from "./components/preview";
import QK from "./components/qk";
import QKControls from "./components/qk/controls/controls";
import QKQuestionRoute from "./components/qk/questionroute/QuestionRoute";
import QKNewQuestion from "./components/qk/newquestion/NewQuestion";
import QKHelp from "./components/qk/help/Help";
import QKProfile from "./components/qk/profile/Profile";
import QKSubjectPicker from "./components/qk/subjectpicker/SubjectPicker";
import UserActionsMenu from "./components/user-actions-menu";

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
    const inQK = window.location.pathname.includes("/qk");

    return (
      <Provider ux={ux}>
        <BrowserRouter ref={br => (this.router = br)}>
          <Grid fluid className={"exercises" + (inQK ? " qk" : "")}>
            {!inQK ? (
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
                <UserActionsMenu user={user} />
              </Navbar>
            ) : (
              <Route path="/qk" component={QKControls} />
            )}
            <div className={"exercises-body" + (inQK ? " qk" : "")}>
              <Route path="/search" component={Search} />
              <Route path="/exercise/:uid" component={Exercise} />
              <Route path="/preview/:uid" component={Preview} />
              <Route path="/qk/home" component={QK} />
              <Route path="/qk/questions" component={QKQuestionRoute} />
              <Route path="/qk/new-question" component={QKNewQuestion} />
              <Route path="/qk/help" component={QKHelp} />
              <Route path="/qk/subject-picker" component={QKSubjectPicker} />
              <Route path="/qk/profile" component={QKProfile} />
            </div>
          </Grid>
        </BrowserRouter>
      </Provider>
    );
  }
}

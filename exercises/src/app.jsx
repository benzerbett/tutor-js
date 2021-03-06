import React from 'react';
import { Container, Navbar, Nav } from 'react-bootstrap';
import { BrowserRouter, Route } from 'react-router-dom';
import { Provider, observer } from 'mobx-react';
import { action } from 'mobx';
import UX from './ux';
import Search from './components/search';
import ExerciseMap from './models/exercises';
import Exercise from './components/exercise';
import Preview from './components/preview';
import Toasts from 'shared/components/toasts';
import UserActionsMenu from './components/user-actions-menu';

export default class App extends React.Component {

  ux = new UX();

  @action.bound onSearch(ev) {
    ev.preventDefault();
    this.router.history.push(ev.currentTarget.pathname);
  }

  @action.bound onNew(ev) {
    ev.preventDefault();
    ExerciseMap.createNewRecord();
    this.router.history.push(ev.currentTarget.pathname);
  }

  render() {
    const { ux, props: { data: { user } } } = this;

    return (
      <Provider ux={ux}>
        <BrowserRouter ref={br => this.router = br}>
          <div>
            <Navbar bg="light" expand="lg">
              <Navbar.Brand href="#home">OX Exercises</Navbar.Brand>
              <Navbar.Collapse>
                <Nav className="exercise-navbar-controls" >
                  <Nav.Link onClick={this.onSearch} href="/search">
                    Search
                  </Nav.Link>
                  <Nav.Link onClick={this.onNew} href="/exercise/new">
                    New
                  </Nav.Link>
                  <Route path="/search" component={Search.Controls} />
                  <Route path="/exercise/:uid" component={Exercise.Controls} />
                  <Route path="/preview/:uid" component={Preview.Controls} />
                </Nav>
              </Navbar.Collapse>
              <UserActionsMenu user={user} />
            </Navbar>
            <Container fluid className="openstax exercises">
              <Toasts />
              <div className="exercises-body">
                <Route path="/search" component={Search} />
                <Route path="/exercise/:uid" component={Exercise} />
                <Route path="/preview/:uid" component={Preview} />
              </div>
            </Container>
          </div>
        </BrowserRouter>
      </Provider>
    );
  }

}

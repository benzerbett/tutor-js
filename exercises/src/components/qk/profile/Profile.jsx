import React from "react";
import "./Profile.css";
import {
  TabContent,
  TabPane,
  Nav,
  NavItem,
  NavLink,
  Card,
  Button,
  CardTitle,
  CardText,
  Row,
  Col,
  CardBody,
  Jumbotron,
} from "reactstrap";
import classnames from "classnames";
import { LinkContainer } from "react-router-bootstrap";
import QKMyQuestions from './../myquestions/myquestions';

export default class Profile extends React.Component {
  constructor(props) {
    super(props);
    this.toggle = this.toggle.bind(this);
    this.state = {
      activeTab: "1"
    };
  }
  toggle(tab) {
    if (this.state.activeTab !== tab) {
      this.setState({
        activeTab: tab
      });
    }
  }
  render() {
    return (
      <div>

        <div>
          <Jumbotron id="jumbo">
            <h1 className="display-3">
              <img
                id="img"
                width="140"
                style={{paddingRight:25}}
                src="http://www.piachievers.com/img/users-female-2.png"
                alt="Card image cap"
              />
                John Adams
            </h1>
            <p className="lead" style={{paddingLeft: 140}}>
              This is a page where you can see your personal
              information, your progress, create new set of questions,
              and go through your stored questions.
            </p>
          </Jumbotron>
        </div>


        <Nav tabs style={{paddingLeft: 25}}>
          <NavItem>
            <NavLink
              className={classnames({ active: this.state.activeTab === "1" })}
              onClick={() => {
                this.toggle("1");
              }}
            >
              Profile
            </NavLink>
          </NavItem>
          <NavItem>
            <NavLink
              className={classnames({ active: this.state.activeTab === "2" })}
              onClick={() => {
                this.toggle("2");
              }}
            >
              Questions
            </NavLink>
          </NavItem>
          <NavItem>
            <NavLink
              className={classnames({ active: this.state.activeTab === "3" })}
              onClick={() => {
                this.toggle("3");
              }}
            >
              Draft
            </NavLink>
          </NavItem>
        </Nav>

        <TabContent activeTab={this.state.activeTab}>
          <TabPane tabId="1">
            <Row>
              <Col sm="12">
                <div>
                  <div id="face">
                    <Card>
                      <CardBody style={{paddingLeft: 25}}>
                      <p id = "profile">
                        <strong>Name: </strong> John Adams
                      </p>
                      <p id = "profile">
                        <strong>School: </strong> Rice University
                      </p>
                      <p id = "profile">
                        <strong>Subject(s) Taught: </strong> English
                      </p>
                      <p id = "profile">
                        <strong>QK Standing: </strong> Valued Contributor
                      </p>
                        <Button>Edit</Button>
                      </CardBody>
                    </Card>
                  </div>
                </div>
              </Col>
            </Row>
          </TabPane>
          <TabPane tabId="2">
            <Row>
              <Col sm="6">
                <Card body style={{paddingLeft:25}}>
                  <CardTitle>Create New Questions</CardTitle>
                  <CardText>
                    Create new set of questions and get more credit!
                  </CardText>
                  <LinkContainer to="/exercise/new">
                    <Button>Create a question</Button>
                  </LinkContainer>
                </Card>
              </Col>
              <Col sm="6">
                <Card body>
                  <CardTitle>Question Library</CardTitle>
                  <CardText>Your authored questions</CardText>
                  <QKMyQuestions />
                </Card>
              </Col>
            </Row>
          </TabPane>
        </TabContent>
      </div>
    );
  }
}

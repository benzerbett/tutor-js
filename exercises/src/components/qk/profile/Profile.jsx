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
  CardImg,
  CardBody,
  CardSubtitle,
  Jumbotron,
  Progress
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
        <Nav tabs>
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
                  <Jumbotron id="jumbo">
                    <h1 className="display-3">
                      Welcome to Question Kitchen, John!
                    </h1>
                    <p className="lead">
                      This is a page where you can see your personal
                      information, your progress, create new set of questions,
                      and go through your stored questions
                    </p>
                    <hr className="my-2" />
                    <div>
                      <div>
                        <div className="text-center">Your Progress</div>
                        <Progress multi>
                          <Progress bar value="15">
                            Calculus
                          </Progress>
                          <Progress bar color="success" value="30">
                            English
                          </Progress>
                          <Progress bar color="info" value="25">
                            Biology
                          </Progress>
                          <Progress bar color="warning" value="20">
                            Statistics
                          </Progress>
                          <Progress bar color="danger" value="5">
                            Chemistry
                          </Progress>
                        </Progress>
                      </div>
                    </div>
                    <p className="lead">
                      <Button color="primary">Learn More</Button>
                    </p>
                  </Jumbotron>
                  <div id="face">
                    <Card>
                      <img
                        id="img"
                        top
                        width="15%"
                        src="http://www.piachievers.com/img/users-female-2.png"
                        alt="Card image cap"
                      />
                      <CardBody>
                        <CardTitle id="jumbo">John King </CardTitle>
                        <CardSubtitle id="jumbo">
                          Cascade High School
                        </CardSubtitle>
                        <CardSubtitle id="jumbo">English teacher</CardSubtitle>
                        <CardText />
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
                <Card body>
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

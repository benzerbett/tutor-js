import React from "react";
import { Button } from 'reactstrap';
import { Link } from 'react-router-dom';
import "./qk/qk.css";
import { observer } from "mobx-react";
import kitchen from "./qk/kitchen.png";

@observer
export default class QK extends React.Component {
  render() {
    return (
      <div className="mt-5">
        <div id="welcome" className="row">
          <div className="col-7">
            <img
              className="kitchen-picture"
              src={kitchen}
              alt="a cartoon kitchen"
            />
          </div>
          <div className="col-5">
            Welcome to
            <div className="bigger">Question </div>
            <div className="bigger ml-2">Kitchen </div>

            <Link to="/qk/subjects">
              <Button color = "warning" size="lg">
                Menu
              </Button>
            </Link> {' '}

            <Link to="/qk/help">
              <Button color="info" size = "lg">
                About Us
              </Button>
            </Link>

          </div>
        </div>
      </div>
    );
  }
}

import React from "react";
import "./qk/qk.css";
import { observer } from "mobx-react";
import kitchen from "./qk/kitchen.png";

@observer
export default class QK extends React.Component {
  render() {
    return (
      <div className="mt-5 qk">
        <div id="welcome" className="row">
          <div className="col-7">
            <img
              className="kitchen-picture"
              src={kitchen}
              alt="a cartoon kitchen"
            />
          </div>
          <div className="col-5">
            Welcome to <br />
            <div className="bigger">Question </div>
            <div className="bigger ml-2">Kitchen </div>
          </div>
        </div>
      </div>
    );
  }
}

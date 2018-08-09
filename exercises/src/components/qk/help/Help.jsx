import React from 'react'
import { observer } from 'mobx-react';
import './Help.css'
import {
    Card,
    CardBody,
} from 'reactstrap'


export default class Help extends React.Component {
    render() {
        return (
            <div className="qk">
                <Card className='m-5'>
                    <CardBody>
                      <h1>About Us</h1>
                      <p>
                        Question Kitchen is a free platform for instructors across the globe
                        to create and evaluate questions that are made by other instructors.
                        Our goal is to build a worldwide community where instructors can build
                        upon the work of other instructors to create free, high-quality
                        educational materials for students.
                      </p>

                      <p>
                        Question Kitchen is associated with OpenStax, a nonprofit organization
                        affiliated with Rice University that seeks to expand education accessibility
                        through its library of 29 free, openly-licensed textbooks.
                      </p>

                      <h1>
                        Our Team
                      </h1>

                      <p>Isaac Chang: Business Operations </p>
                      <p> Melinda Ding: Product Management</p>
                      <p>Jose Escalante: Content Development</p>
                      <p>Thera Fu: Software Test Automation</p>
                      <p>Yerin Han: Research Support</p>
                      <p>Jeff Hwang: Software Test Automation</p>
                      <p>Lindsay Josephs: Marketing and Communications</p>
                      <p>Joyce Moon: Project Management</p>
                      <p>Thomas Williamson: Front-End Development</p>

                    </CardBody>
                </Card>
            </div>
        );
    }
}

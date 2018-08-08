import React from 'react'
import { observer } from 'mobx-react';
import { LinkContainer } from 'react-router-bootstrap'
import {
    Card,
    CardTitle,
    CardBody,
} from 'reactstrap'

// The FullRoster iterates over all of the players and creates
// a link to their profile page.
const Subjects = [
    "Calculus",
    "Physics",
    "Chemistry",
    "History",
    "Sociology",
    "Biology",
];

@observer
export default class SubjectPicker extends React.Component {
    render() {
        return (
            <div className="qk">
                <div className="row mx-4">
                    {
                        Subjects.map(p => (
                            <div className="col-3" key={Subjects.indexOf(p)}>
                                <LinkContainer to={"/qk/subject/" + p.toLowerCase()}>
                                    <Card className="mx-1 my-4">
                                        <div className='subject-card'>
                                        <CardBody className="forum">
                                            <CardTitle className="subject">{p}</CardTitle>
                                            <CardBody/>
                                        </CardBody></div>
                                    </Card>
                                </LinkContainer>
                            </div>

                        ))
                    }
                </div>
            </div>
        );
    }

}

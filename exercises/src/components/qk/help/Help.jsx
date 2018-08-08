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
                        <h1>This is where the help page would go</h1>
                    </CardBody>
                </Card>
            </div>
        );
    }
}

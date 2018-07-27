import React from "react";
import {
    Button,
    Card,
    CardTitle,
    CardBody,
    CardText,
    CardFooter
} from 'reactstrap'
import { LinkContainer } from 'react-router-bootstrap'
import Tags from './Tags'
import './QuestionCards.css'

import { Icon } from 'react-icons-kit'
import {copy} from 'react-icons-kit/icomoon/copy'
import {heart} from 'react-icons-kit/icomoon/heart'
import {pencil2} from 'react-icons-kit/icomoon/pencil2'
import {ic_thumb_up} from 'react-icons-kit/md/ic_thumb_up'
import {ic_thumb_down} from 'react-icons-kit/md/ic_thumb_down'


export default class QuestionCard extends React.Component {

    render(){
        const cardbody = (
            <CardBody className='m-3'>
                <CardTitle>
                    {this.props.question.title}
                </CardTitle>
                <CardText className='ml-4'>
                    {this.props.question.body}
                </CardText>
            </CardBody>
        );

        let card;
        if(this.props.link){card = (
                <LinkContainer to={this.props.link}>
                    {cardbody}
                </LinkContainer>)}
        else{card = cardbody}

        return(
            <Card className="m-4 ml-5">
                { card }
                <CardFooter>
                    <div className='row'>
                        <div className='col'>
                            {console.log(this.props.question)}
                            <Tags tags={this.props.question.tags} readOnly={true}/>
                        </div>
                        <div className='col'>
                            <p className='text-sm-right text-muted' style={{fontSize: 15}}>{this.props.question.date}</p>
                        </div>
                    </div>
                    <div className='row float-right'>
                        <Button className='btn-light'><Icon icon={copy} style={{color:'#888987'}}/></Button>
                        <Button className='btn-light'><Icon icon={heart} style={{color:'#f4d0be'}}/></Button>
                        <Button className='btn-light'><Icon icon={pencil2} style={{color:'#888987'}}/></Button>
                        <Button className='btn-light'><Icon icon={ic_thumb_up} style={{color:'#f4d0be'}}/></Button>
                        <Button className='btn-light'><Icon icon={ic_thumb_down} style={{color:'#afd1f4'}}/></Button>
                    </div>
                </CardFooter>
            </Card>
        )
    }
}


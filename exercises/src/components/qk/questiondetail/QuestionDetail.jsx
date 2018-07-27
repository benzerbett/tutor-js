import React from 'react'
import './QuestionDetail.css'
import { LinkContainer } from 'react-router-bootstrap'
import QuestionCard from '../elements/QuestionCards'
import QuestionService from '../../../service/questionService'
import { addBreak } from '../../../service/utilities'
import {
    Button
} from 'reactstrap'

export default class QuestionDetail extends React.Component {

    constructor(props) {
        super(props);
        this.state = ({question: {}});
    }

    componentDidMount(){
        QuestionService
            .get(parseInt(this.props.match.params.id, 10))
            .then((data) => {
                data.body = addBreak(data.body);
                this.setState({question: data});
            }
        );
    }


    render(){
        return (
                <div>
                    <LinkContainer to='/questions'>
                        <Button className="btn btn-outline-mute m-4">
                                Back
                            </Button>
                    </LinkContainer>
                    <QuestionCard question={this.state.question}/>
                </div>
            )
        }
};


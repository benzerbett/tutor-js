import React from 'react'
import './Questions.css'
import QuestionService from '../../../service/questionService'
import { LinkContainer } from 'react-router-bootstrap'
import { addBreak } from '../../../service/utilities'
import {
    Button,
    Card,
    CardBody,
    CardText,
} from 'reactstrap'
import QuestionCard from '../elements/QuestionCards'
import SideBar from '../elements/SideBar'



export default class Questions extends React.Component {

    constructor(props) {
        super(props);
        this.state = ({questions: []});
    }

    componentDidMount(){
        QuestionService.getAll().then((data)=>{
            for(let q in data){data[q].body = addBreak(data[q].body)}
            this.setState({questions: data});
        })
    };

    render(){
        return (
            <div className="row qk">
                <div className="col-8">
                    {
                        this.state.questions.map(p => (
                            <QuestionCard question={p} link={`/questions/${p.id}`} key={p.id}/>
                        ))
                    }
                </div>
                <div className="col-3 mt-4">
                    <LinkContainer to='/new-question'>
                        <Button className="btn btn-outline-dark btn-block">
                            Create Question
                        </Button>
                    </LinkContainer>
                    <Card className="mt-4">
                        <CardBody style={{backgroundColor:'#F8F9FA'}}>
                            <SideBar/>
                            <br/><br/><br/>
                        </CardBody>
                    </Card>
                </div>
            </div>
        )}
}

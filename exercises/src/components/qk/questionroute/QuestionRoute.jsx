import React from 'react'
import { Switch, Route } from 'react-router-dom'
import Questions from './Questions'
import QuestionDetail from '../questiondetail/QuestionDetail'

const QuestionRoute = () => (
    <Switch>
        <Route exact path='/questions' component={Questions}/>
        <Route path='/questions/:id' component={QuestionDetail}/>
    </Switch>
);


export default QuestionRoute

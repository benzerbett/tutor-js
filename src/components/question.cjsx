React = require 'react'
_ = require 'underscore'

Answer = require './answer'
{QuestionActions, QuestionStore} = require '../stores/question'
{AnswerActions, AnswerStore} = require '../stores/answer'

module.exports = React.createClass
  displayName: 'Question'

  getInitialState: -> {}

  changeAnswer: (answerId) ->
    curAnswer = QuestionStore.getCorrectAnswer(@props.id)
    QuestionActions.setCorrectAnswer(@props.id, answerId, curAnswer?.id)
    @props.sync()

  updateStimulus: (event) ->
    QuestionActions.updateStimulus(@props.id, event.target?.value)
    @props.sync()

  updateStem: (event) ->
    QuestionActions.updateStem(@props.id, event.target?.value)
    @props.sync()

  updateFeedback: (event) ->
    QuestionActions.updateFeedback(@props.id, event.target?.value)
    @props.sync()

  addAnswer: ->
    QuestionActions.addNewAnswer(@props.id)
    @props.sync()

  removeAnswer:(answerId) ->
    QuestionActions.removeAnswer(@props.id, answerId)
    @props.sync()

  multipleChoiceClicked: (event) -> QuestionActions.toggleMultipleChoiceFormat(@props.id)
  freeResponseClicked: (event) -> QuestionActions.toggleFreeResponseFormat(@props.id)

  render: ->
    {id} = @props
    answers = []

    for answer in QuestionStore.getAnswers(id)
      answers.push(<Answer key={answer.id} 
        sync={@props.sync}
        id={answer.id} 
        removeAnswer={@removeAnswer} changeAnswer={@changeAnswer}/>)

    if QuestionStore.hasFeedback(id)
      feedback = <div>
        <label>Detailed Solution</label>
        <textarea onChange={@updateFeedback} defaultValue={QuestionStore.getFeedback(id)}></textarea>
      </div>

    <div>
      <div>
        <label>Question Stem</label>
        <textarea onChange={@updateStem} defaultValue={QuestionStore.getStem(id)}></textarea>
      </div>
      <div>
        <label>Question Stimulus</label>
        <textarea onChange={@updateStimulus} defaultValue={QuestionStore.getStimulus(id)}></textarea>
      </div>
      <div>
        <label>Question Formats</label>
      </div>
      <div>
        <input onChange={@multipleChoiceClicked}
          id="multipleChoiceFormat#{id}"
          type="checkbox"
          defaultChecked={QuestionStore.isMultipleChoice(id)} />
        <label htmlFor="multipleChoiceFormat#{id}">Multiple Choice</label>
      </div>
      <div>
        <input onChange={@freeResponseClicked}
          id="freeResponseFormat#{id}"
          type="checkbox"
          defaultChecked={QuestionStore.isFreeResponse(id)} />
        <label htmlFor="freeResponseFormat#{id}">Free Response</label>
      </div>
      {feedback}
      <div>
        <label>
          Answers:
        </label>
        <a className="pull-right" onClick={@addAnswer}>Add New</a>
        <ol>
          {answers}
        </ol>
      </div>
    </div>

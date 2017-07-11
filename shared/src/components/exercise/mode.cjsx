React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'

ArbitraryHtmlAndMath = require '../html'
Question = require '../question'
FreeResponse = require './free-response'



RESPONSE_CHAR_LIMIT = 10000

{propTypes, props} = require './props'
modeType = propTypes.ExerciseStepCard.panel
modeProps = _.extend {}, propTypes.ExFreeResponse, propTypes.ExMulitpleChoice, propTypes.ExReview, mode: modeType

ExMode = React.createClass
  displayName: 'ExMode'
  propTypes: modeProps
  getDefaultProps: ->
    disabled: false
    free_response: ''
    answer_id: ''

  getInitialState: ->
    {free_response, answer_id} = @props

    freeResponse: free_response
    answerId: answer_id
    voice: true


  componentDidMount: ->
    {mode} = @props
    @setFreeResponseFocusState() if mode is 'free-response'

  componentDidUpdate: (prevProps) ->
    {mode, focus} = prevProps
    @setFreeResponseFocusState() if mode is 'free-response' and focus isnt @props.focus

  componentWillReceiveProps: (nextProps) ->
    {free_response, answer_id, cachedFreeResponse} = nextProps

    nextAnswers = {}
    freeResponse = free_response or cachedFreeResponse or ''

    nextAnswers.freeResponse = freeResponse if @state.freeResponse isnt freeResponse
    nextAnswers.answerId = answer_id if @state.answerId isnt answer_id

    @setState(nextAnswers) unless _.isEmpty(nextAnswers)

  setFreeResponseFocusState: ->
    {focus} = @props
    el = ReactDOM.findDOMNode(@refs.freeResponse)
    if focus
      el.focus?()
    else
      el.blur?()

  onFreeResponseChange: ->
    freeResponse = ReactDOM.findDOMNode(@refs.freeResponse)?.value
    if freeResponse.length <= RESPONSE_CHAR_LIMIT
      @setState({freeResponse})
      @props.onFreeResponseChange?(freeResponse)

  onAnswerChanged: (answer) ->
    return if answer.id is @state.answerId or @props.mode isnt 'multiple-choice'
    @setState {answerId: answer.id}
    @props.onAnswerChanged?(answer)

  startDictation: ->
    if window.hasOwnProperty('webkitSpeechRecognition')
      recognition = new webkitSpeechRecognition
      recognition.continuous = false
      recognition.interimResults = false
      recognition.lang = 'en-US'
      recognition.start()

      recognition.onresult = (e) ->
        response = e.results[0][0].transcript
        transcript_el = document.getElementById('transcript')
        if transcript_el == null
          # then it is multiple choice
          if response == "answer" || response == "submit"
            transcript_el = document.getElementById("contine_button")
            transcript_el.focus()
            transcript_el.click()
            recognition.stop()
          else
            if response == "a"
              transcript_el = document.getElementById("a")
            if response == "be" || response == "bee" || response == "B"
              transcript_el = document.getElementById("b")
            if response == "see" || response == "sea"
              transcript_el = document.getElementById("c")
            if response == "d"
              transcript_el = document.getElementById("d")
            if response == "e"
              transcript_el = document.getElementById("e")
            transcript_el.focus()
            transcript_el.click()
            recognition.stop()
            return


        else
          if response == "answer" || response == "submit"
            transcript_el = document.getElementById("contine_button")
            transcript_el.focus()
            transcript_el.click()
            recognition.stop()
          else
            transcript_el = document.getElementById('transcript')
            transcript_el.value += response + " "
            transcript_el.innerHTML += response + " "
            recognition.stop()

            transcript_el.focus()
            transcript_el.click()

        return

      recognition.onerror = (e) ->
        recognition.stop()
        return


  getFreeResponse: ->
    {mode, free_response, disabled} = @props
    {freeResponse} = @state

    if mode is 'free-response'
      <textarea
        id = "transcript"
        aria-labelledby="question response text box"
        disabled={disabled}
        ref='freeResponse'
        placeholder='Enter your response'
        value={freeResponse}
        onChange={@onFreeResponseChange}
        onClick={@onFreeResponseChange}
      />

    else
      <FreeResponse free_response={free_response}/>

  render: ->

    {mode, content, onChangeAnswerAttempt, answerKeySet, choicesEnabled} = @props
    {answerId} = @state

    answerKeySet = null unless choicesEnabled

    questionProperties = [
      'processHtmlAndMath', 'choicesEnabled', 'correct_answer_id', 'task',
      'feedback_html', 'type', 'questionNumber', 'project', 'context', 'focus'
    ]

    questionProps = _.pick(@props, questionProperties)
    if mode is 'multiple-choice'
      changeProps =
        onChange: @onAnswerChanged
    else if mode is 'review'
      changeProps =
        onChangeAttempt: onChangeAnswerAttempt

    htmlAndMathProps = _.pick(@props, 'processHtmlAndMath')

    {stimulus_html} = content
    stimulus = <ArbitraryHtmlAndMath
      {...htmlAndMathProps}
      className='exercise-stimulus'
      block={true}
      html={stimulus_html} /> if stimulus_html?.length > 0

    questions = _.map content.questions, (question) =>
      question = _.omit(question, 'answers') if mode is 'free-response'

      <Question
        {...questionProps}
        {...changeProps}
        key="step-question-#{question.id}"
        model={question}
        answer_id={answerId}
        keySet={answerKeySet}>
        {@getFreeResponse()}
      </Question>



    <div className='openstax-exercise'>
      {stimulus}
      {questions}
      <div onLoad={@startDictation}>
        <img onClick={@startDictation} style={{height:'30px', paddingRight:'10px' }} src="https://cdn2.iconfinder.com/data/icons/metro-uinvert-dock/256/Microphone_1.png" />
      </div>


    </div>


module.exports = {ExMode}

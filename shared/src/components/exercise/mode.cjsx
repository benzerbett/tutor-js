React = require 'react'
ReactDOM = require 'react-dom'
_ = require 'underscore'

ArbitraryHtmlAndMath = require '../html'
Question = require '../question'
FreeResponse = require './free-response'

mic_image = require './speech-symbol.png'
listening_image = require './listening.gif'

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

  # recognizing: true
  # final_transcript = ''
  # recognizing = false
  # ignore_onend = false
  #
  # if window.hasOwnProperty('webkitSpeechRecognition')
  #   recognition = new webkitSpeechRecognition
  #   recognition.continuous = true
  #   recognition.interimResults = true
  #   recognition.lang = 'en-US'
  #
  # recognition.onstart = function() {
  #   recognizing = true;
  #   showInfo('info_speak_now');
  #   start_img.src = 'mic-animate.gif';
  # };


  startDictation: (e) ->
    if window.hasOwnProperty('webkitSpeechRecognition')
      recognition = new webkitSpeechRecognition
      recognition.continuous = true
      recognition.interimResults = false
      recognition.lang = 'en-US'
      recognition.start()
      icon = document.getElementById('speech_icon')
      speech_icon.src = listening_image
      submit_tiggers = ["answer", "submit", "next question", "next",
                        " answer", " submit", " next question", " next"]

      recognition.onstart = () ->
        recognizing = true
        # icon = document.getElementById('speech_icon')
        # speech_icon.src = listening_image

      recognition.onend = () ->
        recognizing = false
        icon = document.getElementById('speech_icon')
        speech_icon.src = mic_image

      recognition.onresult = (e) ->
        transcript_el = document.getElementById('transcript')
        index = e.results.length - 1
        response = e.results[index][0].transcript
        if transcript_el == null
          # then it is multiple choice
          if response in submit_tiggers
            transcript_el = document.getElementById("contine_button")
            transcript_el.focus()
            transcript_el.click()
            # recognition.stop()
          else
            if response == "a" || response == " a"
              transcript_el = document.getElementById("a")
            if response == "be" || response == "bee" || response == "B" ||
                response == " be" || response == " bee" || response == " B"
              transcript_el = document.getElementById("b")
            if response == "see" || response == "sea" || response == " see" || response == " sea"
              transcript_el = document.getElementById("c")
            if response == "d" || response == " d"
              transcript_el = document.getElementById("d")
            if response == "e" || response == " e"
              transcript_el = document.getElementById("e")
            transcript_el.focus()
            transcript_el.click()
            # recognition.stop()

        else
          console.log(response)
          if response in submit_tiggers
            transcript_el = document.getElementById("contine_button")
            transcript_el.focus()
            transcript_el.click()
            # recognition.stop()
          else
            transcript_el = document.getElementById('transcript')
            transcript_el.value += response
            transcript_el.innerHTML += response
            # recognition.stop()
            transcript_el.focus()
            transcript_el.click()
        return

      recognition.onerror = (e) ->
        recognition.stop()
        return

  recognizing: false

  startButton: (event) ->
    if (recognizing)
      recognition.stop()

      return
    recognizing = true
    final_transcript = ''
    recognition.start()
    final_span.innerHTML = ''
    interim_span.innerHTML = ''
    start_img.src = listening_image;
    # @startDictation
    # showInfo('info_allow');
    # showButtons('none');
    # start_timestamp = event.timeStamp;


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
      >
      </textarea>

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
      <div >
        <img id="speech_icon" onClick={@startDictation} style={{height:'30px', paddingRight:'10px' }} src={mic_image} />
      </div>


    </div>


module.exports = {ExMode}

{Testing, expect, _} = require '../helpers/component-testing'

{TimeActions, TimeStore} = require '../../../src/flux/time'

Cell = require '../../../src/components/scores/homework-cell'
PieProgress = require '../../../src/components/scores/pie-progress'


describe 'Student Scores Homework Cell', ->

  beforeEach ->
    @props =
      courseId: '1'
      student:
        name: 'Molly Bloom'
        role: 'student'
      task:
        status:          'in_progress'
        type:            'homework'
        exercise_count: 17
        correct_exercise_count: 9
        correct_on_time_exercise_count: 3
        completed_exercise_count: 11
        completed_on_time_exercise_count: 11



  it 'renders score cell', ->
    Testing.renderComponent( Cell, props: @props ).then ({dom}) =>
      score = ((@props.task.correct_on_time_exercise_count / @props.task.exercise_count) * 100).toFixed(0) + '%'
      expect(dom.querySelector('.score a').innerText).to.equal(score)
      expect(dom.querySelector('.late-caret')).to.be.null

  it 'renders progress cell', ->
    @props.size = 24
    @props.value = 33
    Testing.renderComponent( PieProgress, props: @props ).then ({dom}) ->
      expect(dom.querySelector('g')).to.not.be.null

  it 'renders as not started', ->
    @props.task.completed_exercise_count = 0
    @props.task.completed_on_time_exercise_count = 0
    Testing.renderComponent( Cell, props: @props ).then ({dom}) ->
      expect(dom.querySelector('.worked .not-started')).to.not.be.null

  it 'displays late caret when worked late', ->
    @props.task.completed_on_time_exercise_count = 3
    Testing.renderComponent( Cell, props: @props ).then ({dom}) ->
      expect(dom.querySelector('.late-caret')).to.not.be.null

  it 'displays accepted caret when accepted', ->
    @props.task.completed_on_time_exercise_count = 3
    @props.task.is_late_work_accepted = true
    Testing.renderComponent( Cell, props: @props ).then ({dom}) ->
      expect(dom.querySelector('.late-caret.accepted')).to.not.be.null









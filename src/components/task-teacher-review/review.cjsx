React = require 'react/addons'

{ScrollListenerMixin} = require 'react-scroll-components'
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

_ = require 'underscore'

TaskTeacherReviewExercise = require './exercise'
ScrollTracker = require '../scroll-tracker'


ReviewTracker = React.createClass
  displayName: 'ReviewTracker'
  mixins: [ScrollTracker]
  onScrollPoint: ->
    {topic, route} = @props

    @props.onScrollPoint()

  render: ->
    {type} = @props


Review = React.createClass
  displayName: 'Review'
  propTypes:
    taskId: React.PropTypes.string.isRequired
    focus: React.PropTypes.bool.isRequired

  getDefaultProps: ->
    focus: false

  render: ->
    {taskId, steps, focus} = @props

    stepsProps = _.omit(@props, 'steps', 'focus')

    stepsList = _.map steps, (step, index) ->

      if step.questions
        stepProps = _.extend({}, stepsProps, {content: step})

        item = <TaskTeacherReviewExercise
          {...stepProps}
          id={step.questions[0].id}
          key="task-review-#{step.questions[0].id}"
          # focus on first problem
          focus={focus and index is 0}
        />
      else
        item = <h2>
          <span className='text-success'>
            {step.sectionLabel}
          </span> {step.title}
        </h2>

      item

    <ReactCSSTransitionGroup transitionName="homework-review-problem">
      {stepsList}
    </ReactCSSTransitionGroup>

module.exports = Review

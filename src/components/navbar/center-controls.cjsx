React = require 'react/addons'
Router = require 'react-router'
moment = require 'moment'
classnames = require 'classnames'
_ = require 'underscore'
BS = require 'react-bootstrap'

Icon = require '../icon'
{TaskStore} = require '../../flux/task'
ModalHeader = require 'react-bootstrap/lib/ModalHeader'
PostForm = require '../integrated-forum/post-form'


module.exports = React.createClass
  displayName: 'CenterControls'
  contextTypes:
    router: React.PropTypes.func

  mixins: [React.addons.PureRenderMixin]

  getDefaultProps: ->
    shouldShow: false

  getInitialState: ->
    params = @context.router?.getCurrentParams() or {}
    taskInfo = @getTaskInfo(params)
    controlInfo = @getControlInfo(params)
    showPostModal: false

    _.extend {}, taskInfo, controlInfo

  closePostModal: ->
    @setState({showPostModal:false})

  openPostModal: ->
    @setState({showPostModal:true})

  handlePostSubmit: (newPost)->
    @setState({showPostModal:false})
    ForumActions.save(@props.courseId, newPost)

  componentWillMount: ->
    location = @context.router?.getLocation()
    location.addChangeListener(@updateControls) if location
    TaskStore.on('loaded', @updateTask)

  componentWillUnmount: ->
    location = @context.router?.getLocation()
    location.removeChangeListener(@updateControls) if location
    TaskStore.off('loaded', @updateTask)

  shouldShow: (path) ->
    {shouldShow} = @props
    return true if shouldShow
    return false unless @context.router?

    path ?= @context.router.getCurrentPath()
    matchedPath = @context.router.match(path)
    return false unless matchedPath?.routes

    'viewTaskStep' in _.pluck(matchedPath.routes, 'name')

  update: (getState, params, path) ->
    show = @shouldShow(path)
    unless show
      @setState({show})
      return false

    params ?= @context.router.getCurrentParams()

    state = getState(params)
    @setState(state) if state?

  updateControls: ({path}) ->
    {params} = @context.router.match(path)
    @update(@getControlInfo, params, path)

  updateTask: (taskId) ->
    params = @context.router.getCurrentParams()
    @update(@getTaskInfo) if taskId is params.id

  getTaskInfo: (params) ->
    {id} = params
    task = TaskStore.get(id)

    return {show: false} unless task and task?.type is 'reading'

    show: true
    assignment: task.title
    due: @reformatTaskDue(task.due_at)

  reformatTaskDue: (due_at) ->
    moment(due_at).calendar()

  getControlInfo: (params) ->
    hasMilestones = @hasMilestones(params)
    linkParams = @getLinkProps(params, hasMilestones)

    _.extend {}, linkParams, {hasMilestones}

  hasMilestones: (params) ->
    params.milestones?

  getLinkProps: (params, hasMilestones) ->
    return {show: false} unless params.id and params.stepIndex and params.courseId

    if hasMilestones
      params: _.omit(params, 'milestones')
      to: 'viewTaskStep'
    else
      params: _.extend({milestones: 'milestones'}, params)
      to: 'viewTaskStepMilestones'

  render: ->
    {show, assignment, due, hasMilestones} = @state
    askTooltip = <BS.Tooltip id="ask-tooltip" className="ask-tooltip">Ask a Question</BS.Tooltip>
    topicTags = []
    chapterTags = []

    return null unless show

    linkProps = _.pick @state, 'to', 'params'

    milestonesToggleClasses = classnames 'milestones-toggle',
      'active': hasMilestones

    <div className='navbar-overlay'>
      <div className='center-control'>
        <span className='center-control-assignment'>
          {assignment}
        </span>

        <Icon type='calendar-check-o'
          tooltipProps={placement: 'bottom'}
          tooltip={due} />
        <Router.Link
          {...linkProps}
          ref='milestonesToggle'
          activeClassName=''
          className={milestonesToggleClasses}>
          <Icon type='th' />
        </Router.Link>
        <BS.OverlayTrigger className="ask-tooltip" placement="bottom" overlay={askTooltip}>
          <Icon type='forum-ask'
            onClick={@openPostModal} />
        </BS.OverlayTrigger>
        <BS.Modal className="post-form-modal" show={@state.showPostModal} onHide={@closePostModal}>

          <ModalHeader closeButton className="post-form-header">
            <BS.Modal.Title>{"New Post"}</BS.Modal.Title>
          </ModalHeader>

          <BS.Modal.Body className="post-form-body">
            <PostForm onPostSubmit = {@handlePostSubmit} topicTags = {topicTags} chapterTags = {chapterTags}/>
          </BS.Modal.Body>

          <BS.Modal.Footer>
          </BS.Modal.Footer>

        </BS.Modal>
      </div>
    </div>

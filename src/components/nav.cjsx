React = require 'react'
BS = require 'react-bootstrap'
Router = require 'react-router'

{CurrentUserActions, CurrentUserStore} = require '../flux/current-user'
{CourseStore} = require '../flux/course'

UserName = React.createClass

  getInitialState: ->
    name: CurrentUserStore.getName()

  _update: ->
    this.setState(name: CurrentUserStore.getName())

  componentWillMount: ->
    unless @state.name
      @_addListener()
      CurrentUserActions.loadName()

  render: ->
    <span {...@props}>{@state.name}</span>

  ## These methods are all copied from Loadable.  Extract into mixin?
  _addListener: ->    CurrentUserStore.addChangeListener(@_update)
  _removeListener: -> CurrentUserStore.removeChangeListener(@_update)
  componentWillUnmount: -> @_removeListener()
  componentWillUpdate:  -> @_removeListener()
  componentDidUpdate:   -> @_addListener()



module.exports = React.createClass
  displayName: 'Navigation'

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    course: undefined

  getCourseAsStudent: ->
    {courseId} = @context.router.getCurrentParams()
    course = CourseStore.get(courseId)

  componentWillMount: ->
    course = @getCourseAsStudent()
    @setState({course}) if course

  componentWillReceiveProps: ->
    course = @getCourseAsStudent()
    @setState({course}) if course

  logout: -> CurrentUserActions.logout()

  renderCourseLink: (course) ->
    courseId = course.id

    <Router.Link to='viewStudentDashboard' params={{courseId}} className='navbar-brand'>
      {course.name}
    </Router.Link>

  renderCourseItems: (course) ->
    courseId = course.id

    items = [
      <BS.MenuItem
      href={@context.router.makeHref('viewStudentDashboard', {courseId})}
      eventKey={2}>Dashboard</BS.MenuItem>
      <BS.MenuItem
        href={@context.router.makeHref('viewGuide', {courseId})}
        eventKey={3}>Learning Guide</BS.MenuItem>
      <BS.MenuItem divider />
    ]

  render: ->

    name = 'Pretend Name'

    brand = <Router.Link to='dashboard' className='navbar-brand'>
              <i className='ui-brand-logo'></i>
            </Router.Link>

    if @state.course?
      course = @renderCourseLink(@state.course)
      courseItems = @renderCourseItems(@state.course)

    <BS.Navbar brand={brand} fixedTop fluid>
      {course}
      <BS.Nav right>
        <BS.DropdownButton eventKey={1} title={<UserName/>}>
          {courseItems}
          <BS.MenuItem eventKey={4} onClick={@logout}>Sign Out!</BS.MenuItem>
        </BS.DropdownButton>
      </BS.Nav>
    </BS.Navbar>

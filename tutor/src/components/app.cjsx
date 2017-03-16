React = require 'react'
classnames = require 'classnames'

Router = require '../helpers/router'
Analytics = require '../helpers/analytics'
Navbar = require './navbar'
MatchForTutor = require './match-for-tutor'

{DragDropContext} = require 'react-dnd'
HTML5Backend = require 'react-dnd-html5-backend'

merge = require 'lodash/merge'
{SpyMode} = require 'shared'
{CourseStore} = require '../flux/course'
{TransitionActions, TransitionStore} = require '../flux/transition'
{ LocationSubscriber } = require 'react-router/Broadcasts'
{ default: TourConductor } = require './tours/conductor'

RouteChange = (props) ->
  TransitionActions.load(props.pathname)
  <span />

App = React.createClass
  displayName: 'App'
  contextTypes:
    router: React.PropTypes.object

  childContextTypes:
    courseId: React.PropTypes.string

  componentDidMount: ->
    @storeHistory()
    Analytics.setTracker(window.ga)

  componentDidUpdate: ->
    @storeHistory()

  storeHistory:  ->
    Analytics.onNavigation(@props.location.pathname)
    TransitionActions.load(@props.location.pathname)

  render: ->
    params = Router.currentParams()
    {courseId} = params

    classNames = classnames('tutor-app', 'openstax-wrapper', {
      'is-college':     courseId? and CourseStore.isCollege(courseId)
      'is-high-school': courseId? and CourseStore.isHighSchool(courseId)
    })

    <div className={classNames}>
      <LocationSubscriber>{RouteChange}</LocationSubscriber>
      <TourConductor>
        <SpyMode.Wrapper>
          <Navbar {...@props}/>
          <MatchForTutor routes={Router.getRenderableRoutes()} />
        </SpyMode.Wrapper>
      </TourConductor>
    </div>


module.exports = DragDropContext(HTML5Backend)(App)

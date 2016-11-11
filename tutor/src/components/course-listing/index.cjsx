_ = require 'lodash'
React = require 'react'
BS = require 'react-bootstrap'
{Redirect, Link} = require 'react-router'
classnames = require 'classnames'

Router = require '../../helpers/router'

WindowHelpers = require '../../helpers/window'

{CourseListingActions, CourseListingStore} = require '../../flux/course-listing'
{CourseStore} = require '../../flux/course'
{CurrentUserStore} = require '../../flux/current-user'
{RefreshButton} = require 'shared'
EmptyCourses    = require '../course-listing/empty'
CourseData = require '../course-data-mixin'

{Course, CoursePastTeacher} = require './course'

getReactBaseName = (context) -> _.kebabCase(context.constructor.displayName)

CourseLink = ({courseId, name, is_concept_coach}) ->
  props = CourseData.getCourseDataProps(courseId)
  <BS.Row data-course-id={courseId}>
    <BS.Col {...props} className='tutor-booksplash-course-item' xs={12}>
      <Link
          className='tutor-course-item'
          to={Router.makePathname('dashboard', {courseId: courseId})}
      >
        {name}
      </Link>
      <div className='course-type-flag'>
        {if is_concept_coach then'Concept Coach' else 'Tutor'}
      </div>
    </BS.Col>
  </BS.Row>

CourseLink.displayName = "CourseLink"

wrapCourseItem = (Item, course) ->
  <BS.Col key="course-listing-item-wrapper-#{course.id}" md={3} sm={4}>
    <Item course={course} />
  </BS.Col>

CourseListingBase = React.createClass
  displayName: 'CourseListingBase'
  render: ->
    {courses, Item, className} = @props
    sectionClasses = classnames('course-listing-section', className)

    <BS.Row className={sectionClasses}>
      {_.map(courses, _.partial(wrapCourseItem, Item))}
    </BS.Row>


AddCourseArea = ->
  <div className='course-listing-add'><p>Add a course</p></div>

CourseListingCurrent = React.createClass
  displayName: 'CourseListingCurrent'
  NoCourses: ->
    <BS.Row>
      <BS.Col md={12}>
        <p>There are no current courses</p>
      </BS.Col>
    </BS.Row>

  Title: ->
    baseName = getReactBaseName(@)

    <BS.Row className="#{baseName}-title">
      <BS.Col md={12}>
        <h1>Current Courses</h1>
      </BS.Col>
    </BS.Row>

  AddCourses: ->
    baseName = getReactBaseName(@)

    <BS.Row className="#{baseName}-add">
      {wrapCourseItem(AddCourseArea, {id: 'new'})}
    </BS.Row>

  render: ->
    {courses} = @props
    baseName = getReactBaseName(@)

    <BS.Grid className={baseName}>
      <@Title />
      {if _.isEmpty(courses)
        <@NoCourses />
      else
        <CourseListingBase
          className="#{baseName}-section"
          courses={courses}
          Item={Course}
        />}
      <@AddCourses />
    </BS.Grid>

CourseListingPast = React.createClass
  displayName: 'CourseListingPast'
  NoCourses: ->
    null

  Title: ->
    baseName = getReactBaseName(@)

    <BS.Row className="#{baseName}-title">
      <BS.Col md={12}>
        <h1>Past Courses</h1>
      </BS.Col>
    </BS.Row>

  render: ->
    {courses} = @props
    baseName = getReactBaseName(@)

    <BS.Grid className={baseName}>
      {if _.isEmpty(courses)
        <@NoCourses />
      else
        [
          <@Title key="#{baseName}-title"/>
          <CourseListingBase
            className="#{baseName}-section"
            courses={courses}
            Item={CoursePastTeacher}
            key="#{baseName}-section"/>
        ]}
    </BS.Grid>


CourseListing = React.createClass
  displayName: 'CourseListing'

  contextTypes:
    router: React.PropTypes.object

  wrapCourseItem: (Item, course) ->
    <BS.Col key="course-listing-item-wrapper-#{course.id}" md={3} sm={4}>
      <Item course={course} />
    </BS.Col>

  shouldRedirect: (currentCourses) ->
    currentCourses.length is 1 and CurrentUserStore.getCourseRole(currentCourses[0].id) is 'student'

  shouldShowEmpty: (currentCourses, pastCourses) ->
    _.isEmpty(currentCourses) and _.isEmpty(pastCourses) # and some way to determine if student?!

  render: ->
    [currentCourses, pastCourses] = CourseListingStore.coursesWithRolesByActive()

    if @shouldShowEmpty(currentCourses, pastCourses)
      <EmptyCourses />
    else if @shouldRedirect(currentCourses, pastCourses)
      <Redirect to={Router.makePathname('dashboard', {courseId: currentCourses[0].id})} />
    else
      <div className='course-listing '>
        <CourseListingCurrent courses={currentCourses}/>
        <CourseListingPast courses={pastCourses}/>
      </div>



module.exports = CourseListing

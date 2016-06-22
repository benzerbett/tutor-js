_ = require 'underscore'
moment = require 'moment-timezone'

Builder = require '../../../../src/components/task-plan/builder'
{TaskPlanActions, TaskPlanStore} = require '../../../../src/flux/task-plan'
{Testing, sinon, expect, _, React} = require '../../helpers/component-testing'
{ExtendBasePlan, PlanRenderHelper} = require '../../helpers/task-plan'

{CourseListingActions, CourseListingStore} = require '../../../../src/flux/course-listing'
{CourseStore} = require '../../../../src/flux/course'

{TimeStore} = require '../../../../src/flux/time'
TimeHelper = require '../../../../src/helpers/time'
TutorDateFormat = TimeStore.getFormat()
ISO_DATE_FORMAT = 'YYYY-MM-DD'

twoDaysBefore = moment(TimeStore.getNow()).subtract(2, 'days').format(ISO_DATE_FORMAT)
yesterday = moment(TimeStore.getNow()).subtract(1, 'day').format(ISO_DATE_FORMAT)
tomorrow = moment(TimeStore.getNow()).add(1, 'day').format(ISO_DATE_FORMAT)
dayAfter = moment(TimeStore.getNow()).add(2, 'day').format(ISO_DATE_FORMAT)

getDateString = (value) -> TimeHelper.getMomentPreserveDate(value).format(TutorDateFormat)
getISODateString = (value) -> TimeHelper.getMomentPreserveDate(value).format(ISO_DATE_FORMAT)

COURSES = require '../../../../api/user/courses.json'
NEW_READING = ExtendBasePlan({id: "_CREATING_1", settings: {page_ids: []}}, false, false)
PUBLISHED_MODEL = ExtendBasePlan({
  id: '1'
  title: 'hello',
  description: 'description',
  published_at: twoDaysBefore}, {opens_at: twoDaysBefore, due_at: yesterday, target_id: COURSES[0].periods[0].id})

helper = (model, routerQuery) -> PlanRenderHelper(model, Builder, {}, {}, routerQuery)

fakePeriodDisable = (element, disabledPeriod) ->
  fakeEvent =
    target:
      checked: false

  element.togglePeriodEnabled(disabledPeriod, fakeEvent)

fakePeriodEnable = (element, enabledPeriod) ->
  fakeEvent =
    target:
      checked: true

  element.togglePeriodEnabled(enabledPeriod, fakeEvent)

describe 'Task Plan Builder', ->
  beforeEach ->
    TaskPlanActions.reset()
    CourseListingActions.loaded(COURSES)

  it 'should load expected plan', ->
    helper(PUBLISHED_MODEL).then ({dom}) ->
      expect(dom.querySelector('#reading-title').value).to.equal(PUBLISHED_MODEL.title)
      descriptionValue = dom.querySelector('.assignment-description textarea').value
      expect(descriptionValue).to.equal(PUBLISHED_MODEL.description)

  it 'should allow editable periods radio if plan is not visible', ->
    helper(NEW_READING).then ({dom}) ->
      expect(dom.querySelector('#show-periods-radio')).to.not.be.null
      expect(dom.querySelector('#hide-periods-radio')).to.not.be.null

  it 'should not allow editable periods radio if plan is visible', ->
    helper(PUBLISHED_MODEL).then ({dom, element}) ->
      expect(dom.querySelector('#show-periods-radio')).to.be.null
      expect(dom.querySelector('#hide-periods-radio')).to.be.null
      expect(element.state.isVisibleToStudents).to.be.true

  it 'should not allow editable open date if plan is visible', ->
    helper(PUBLISHED_MODEL).then ({dom, element}) ->
      element.setAllPeriods()
      datepicker = dom.querySelector('.-assignment-open-date .datepicker__input-container input')
      inputDom = dom.querySelector('.-assignment-open-date .-tutor-date-input input')

      expect(datepicker).to.be.null
      expect(inputDom.disabled).to.be.true


  it 'hides periods by default', ->
    helper(NEW_READING).then ({dom, element}) ->
      expect(dom.querySelector('.tasking-plan.tutor-date-input')).to.be.null

  it 'can show individual periods', ->
    helper(NEW_READING).then ({dom, element}) ->
      element.setIndividualPeriods()
      expect(dom.querySelectorAll('.tasking-plan.tutor-date-input').length).to.equal(COURSES[0].periods.length)

  it 'sorts individual periods alphanumerically', ->
    helper(NEW_READING).then ({dom, element}) ->
      element.setIndividualPeriods()
      labels = _.pluck(dom.querySelectorAll('.tasking-plan label'), 'textContent')
      expect( labels ).to.be.deep.equal(['1st', '3rd', '4th', '5th', '6th', '10th', 'AAA', 'zZZ'])

  it 'does not load a default due at for all periods', ->
    helper(NEW_READING).then ({dom, element}) ->
      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(dueAt).to.not.be.ok
      element.setIndividualPeriods()
      element.setAllPeriods()
      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(dueAt).to.not.be.ok

  it 'can clear due at when there is no common due at', ->
    firstPeriod = COURSES[0].periods[0]
    secondPeriod = COURSES[0].periods[1]

    helper(NEW_READING).then ({dom, element}) ->
      #set individual periods
      element.setIndividualPeriods()

      #set due dates to be different
      element.setDueAt(getISODateString(tomorrow), firstPeriod)
      element.setDueAt(getISODateString(dayAfter), secondPeriod)

      #set all periods
      element.setAllPeriods()

      #due at should be cleared
      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(dueAt).to.not.be.ok

  it 'will default to queried due date if no common due at with a due date query string', ->
    firstPeriod = COURSES[0].periods[0]
    secondPeriod = COURSES[0].periods[1]

    helper(NEW_READING, {due_at: getISODateString(dayAfter)} ).then ({dom, element}) ->
      #set individual periods
      element.setIndividualPeriods()

      #set due dates to be different
      element.setDueAt(getISODateString(tomorrow), firstPeriod)
      element.setDueAt(getISODateString(dayAfter), secondPeriod)

      #set all periods
      element.setAllPeriods()

      #due at should reset to query string due at
      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(getISODateString(dueAt)).to.be.equal(getISODateString(dayAfter))

  it 'can update open date with date obj', ->
    helper(NEW_READING).then ({dom, element}) ->
      element.setOpensAt(getISODateString(dayAfter))
      opensAt = TaskPlanStore.getOpensAt(NEW_READING.id)
      expect(getISODateString(opensAt)).to.be.equal(getISODateString(dayAfter))

  it 'can update open date with string', ->
    helper(NEW_READING).then ({dom, element}) ->
      element.setOpensAt(getISODateString(tomorrow))
      opensAt = TaskPlanStore.getOpensAt(NEW_READING.id)
      expect(getISODateString(opensAt)).to.be.equal(getISODateString(tomorrow))

  it 'can update due date with date obj', ->
    helper(NEW_READING).then ({dom, element}) ->
      element.setDueAt(getISODateString(dayAfter))
      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(getISODateString(dueAt)).to.be.equal(getISODateString(dayAfter))

  it 'can update due date with string', ->
    helper(NEW_READING).then ({dom, element}) ->
      element.setDueAt(getISODateString(tomorrow))
      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(getISODateString(dueAt)).to.be.equal(getISODateString(tomorrow))

  it 'can disable individual periods', ->
    disabledPeriod = COURSES[0].periods[1]
    anotherDisabledPeriod = COURSES[0].periods[7]

    helper(NEW_READING).then ({dom, element}) ->
      element.setIndividualPeriods()

      fakePeriodDisable(element, disabledPeriod)
      fakePeriodDisable(element, anotherDisabledPeriod)

      taskings = TaskPlanStore.getEnabledTaskings(NEW_READING.id)
      expect(taskings).to.have.length(COURSES[0].periods.length - 2)
      expect(taskings).to.not.have.members([disabledPeriod, anotherDisabledPeriod])

  it 'can update open date for individual period', ->
    period = COURSES[0].periods[0]
    anotherPeriod = COURSES[0].periods[2]
    disabledPeriod = COURSES[0].periods[1]
    anotherDisabledPeriod = COURSES[0].periods[7]

    helper(NEW_READING).then ({dom, element}) ->
      element.setIndividualPeriods()

      fakePeriodDisable(element, disabledPeriod)
      fakePeriodDisable(element, anotherDisabledPeriod)
      element.setOpensAt(getISODateString(dayAfter), period)

      opensAt = TaskPlanStore.getOpensAt(NEW_READING.id)
      expect(opensAt).to.not.be.ok

      opensAt = TaskPlanStore.getOpensAt(NEW_READING.id, period.id)
      expect(getISODateString(opensAt)).to.be.equal(getISODateString(dayAfter))

  it 'can update due date for individual period', ->
    period = COURSES[0].periods[0]
    disabledPeriod = COURSES[0].periods[1]
    anotherPeriod = COURSES[0].periods[2]

    helper(NEW_READING).then ({dom, element}) ->
      element.setIndividualPeriods()

      fakePeriodDisable(element, disabledPeriod)
      element.setDueAt(getISODateString(dayAfter), anotherPeriod)
      element.setDueAt(getISODateString(tomorrow), period)

      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(dueAt).to.not.be.ok

      dueAt = TaskPlanStore.getDueAt(NEW_READING.id, period.id)
      expect(getISODateString(dueAt)).to.be.equal(getISODateString(tomorrow))

  it 'sets the correct moment timezone on mount', ->
    courseId = COURSES[0].periods[0].id
    helper(NEW_READING).then ({dom, element}) ->
      expect([undefined, CourseStore.getTimezone(courseId)]).to.contain(moment().tz())

  it 'name and description fields are enabled when plan is past due', ->
    helper(PUBLISHED_MODEL).then ({dom}) ->
      expect(dom.querySelector('#reading-title').disabled).to.be.false
      expect(dom.querySelector('.assignment-description textarea').disabled).to.be.false

  it 'sets the default due date when based on query string', ->
    helper(NEW_READING, {due_at: getISODateString(dayAfter)} ).then ({dom, element}) ->
      dueAt = TaskPlanStore.getDueAt(NEW_READING.id)
      expect(getISODateString(dueAt)).to.be.equal(getISODateString(dayAfter))
      expect(dom.querySelector('.-assignment-due-date .datepicker__input-container input').value)
        .to.be.equal(getDateString(dayAfter))
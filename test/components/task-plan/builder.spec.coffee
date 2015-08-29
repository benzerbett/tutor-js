_ = require 'underscore'

Builder = require '../../../src/components/task-plan/builder'
{TaskPlanActions, TaskPlanStore} = require '../../../src/flux/task-plan'
{Testing, sinon, expect, _, React} = require '../helpers/component-testing'
{ExtendBasePlan, PlanRenderHelper} = require '../helpers/task-plan'

yesterday = (new Date(Date.now() - 1000 * 3600 * 24)).toString()

NEW_READING = ExtendBasePlan({id: "_CREATING_1", settings: {page_ids: []}})
PUBLISHED_MODEL = ExtendBasePlan({
  title: 'hello',
  description: 'description',
  published_at: yesterday}, {opens_at: yesterday})

helper = (model) -> PlanRenderHelper(model, Builder)


describe 'Task Plan Builder', ->
  beforeEach ->
    TaskPlanActions.reset()

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
      expect(element.refs.openDate.props.disabled).to.be.true
      
  it 'hides periods by default', ->
    helper(NEW_READING).then ({dom, element}) ->
      expect(dom.querySelector('.tasking-plan.tutor-date-input')).to.be.null
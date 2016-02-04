selenium = require 'selenium-webdriver'
{expect} = require 'chai'
{TestHelper} = require './test-element'
{PeriodReviewTab} = require './items'


COMMON_ELEMENTS =
  ccScoresLink:
    linkText: 'Student Scores'
  ccScoresLink:
    linkText: 'View Detailed Scores'
  nameHeaderSort:
    css: '.header-cell.is-ascending'
  dataHeaderSort:
    css: '.header-cell'
  generateExport:
    css: '.export-button'
  downloadExport:
    css: '.export-button-buttons a'
  hsNameLink:
    css: '.name-cell a.student-name'
  hsReviewLink:
    css: 'a.review-plan'
  assignmentByType: (type) ->
    css: "a.scores-cell[data-assignment-type='#{type}']"


class ScoresHelper extends TestHelper
  constructor: (testContext, testElementLocator) ->

    testElementLocator ?=
      css: '.course-scores-container'

    super(testContext, testElementLocator, COMMON_ELEMENTS)
    @setCommonHelper('periodReviewTab', new PeriodReviewTab(@test))

  # this could be moved to cc-dashboard helper at some point
  goCCScores: =>
    @test.utils.windowPosition.scrollTop()
    @el.ccScoresLink.get().click()

  doneGenerating: =>
    @test.driver.wait =>
      @test.driver.isElementPresent(css: downloadExport)




React = require 'react'
_ = require 'underscore'
classnames = require 'classnames'
tasks = require './collection'

{ChapterSectionMixin} = require 'openstax-react-components'

TaskTitle = React.createClass
  displayName: 'TaskTitle'
  mixins: [ChapterSectionMixin]
  render: ->
    {taskId, cnxUrl} = @props
    moduleInfo = tasks.getModuleInfo(taskId, cnxUrl)
    section = @sectionFormat(moduleInfo.chapter_section)

    sectionProps =
      className: 'chapter-section-prefix'
    sectionProps['data-section'] = section if section?

    linkProps =
      href: moduleInfo.link

    if moduleInfo.title
      linkProps.target = '_blank'
      title = <span {...sectionProps}>
        {moduleInfo.title}
      </span>
    else
      noTitle = <span className='no-title'>Back to Book</span>

    titleClasses = classnames 'concept-coach-title',
      'no-title': not moduleInfo.title?

    <h3 className={titleClasses}>
      {title}
      <a {...linkProps}>
        {noTitle}
        <i className='fa fa-book'></i>
      </a>
    </h3>

module.exports = {TaskTitle}

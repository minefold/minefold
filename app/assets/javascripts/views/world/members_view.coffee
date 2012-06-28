#= require ./page_view

class Application.WorldMembersView extends Application.WorldPageView

  render: =>
    for member in @model.get('members')
      $(@el).append(member.username)


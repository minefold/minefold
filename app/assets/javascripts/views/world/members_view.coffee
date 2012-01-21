#= require ./page_view

class Mf.WorldMembersView extends Mf.WorldPageView

  render: =>
    for member in @model.get('members')
      $(@el).append(member.username)


`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  # none yet
  @resource 'calculations', ->
    @route 'new', ->
      @route 'settings'
      @route 'protocol'
      @route 'preparation'

`export default Router`

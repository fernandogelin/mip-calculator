`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  # none yet
  @resource 'calculations', ->
    @route 'new'

`export default Router`

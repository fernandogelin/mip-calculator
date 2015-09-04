`import Ember from 'ember'`

IndexRoute = Ember.Route.extend
  beforeModel: -> @transitionTo 'calculations.new'

`export default IndexRoute`

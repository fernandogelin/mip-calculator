`import Ember from 'ember'`

CalculationsNewRoute = Ember.Route.extend
  model: -> @store.createRecord 'mip-capture-calculation'
  afterModel: -> @transitionTo 'calculations.new.settings'

`export default CalculationsNewRoute`

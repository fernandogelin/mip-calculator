`import Ember from 'ember'`

CalculationsNewRoute = Ember.Route.extend
  model: -> @store.createRecord 'mip-capture-calculation'

`export default CalculationsNewRoute`

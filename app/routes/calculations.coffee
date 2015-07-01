`import Ember from 'ember'`

CalculationsRoute = Ember.Route.extend
  model: -> @store.find 'mip-capture-calculation'

`export default CalculationsRoute`

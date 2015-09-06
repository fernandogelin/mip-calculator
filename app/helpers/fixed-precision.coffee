`import Ember from 'ember'`

# This function receives the params `params, hash`
fixedPrecision = (params) ->
  number = params[0]
  precision = params[1] || 3
  number.toFixed precision

FixedPrecisionHelper = Ember.HTMLBars.makeBoundHelper fixedPrecision

`export { fixedPrecision }`

`export default FixedPrecisionHelper`

`import { test, moduleFor } from 'ember-qunit'`

moduleFor 'route:calculation/form', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route

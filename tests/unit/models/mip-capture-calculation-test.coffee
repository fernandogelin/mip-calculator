`import { test, moduleForModel } from 'ember-qunit'`

moduleForModel 'mip-capture-calculation', {
  # Specify the other units that are required for this test.
  needs: []
}

test 'it exists', (assert) ->
  model = @subject()
  # store = @store()
  assert.ok !!model

test 'MIP copy count required is properly calculated', (assert) ->
  expect 2
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    mipCopyCountRequired = record1.get 'mip_copy_count_required'
    assert.equal mipCopyCountRequired, 26400000
    
    record2 = store.createRecord 'mip-capture-calculation'
    record2.set 'dna_amount_per_reaction', 20
    mipCopyCountRequired = record2.get 'mip_copy_count_required'
    assert.equal mipCopyCountRequired, 5280000
    
test 'MIPs required is properly calculated', (assert) -> 
  expect 2
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    mipsRequired = record1.get 'mips_required'
    assert.equal mipsRequired, 0.000042375601926163725
    
    record2 = store.createRecord 'mip-capture-calculation'
    record2.set 'dna_amount_per_reaction', 20
    mipsRequired = record2.get 'mips_required'
    assert.equal mipsRequired, 0.000008475120385232745
    
test 'probe concentration is properly calculated', (assert) ->
  expect 2
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'mip_concentration', 5
    record1.set 'mip_volume', 0.18
    record1.set 'phosphorylation_reaction_volume', 200
    probeConcentration = record1.get 'probe_concentration'
    assert.equal probeConcentration, 0.0045
    
    record2 = store.createRecord 'mip-capture-calculation'
    record2.set 'mip_concentration', 100
    record2.set 'mip_volume', 0.5
    record2.set 'phosphorylation_reaction_volume', 100
    probeConcentration = record2.get 'probe_concentration'
    assert.equal probeConcentration, 0.5
    
    


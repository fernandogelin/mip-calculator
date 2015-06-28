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
    mipsRequired = record1.get 'mips_amount_required'
    assert.equal mipsRequired, 0.000042375601926163725
    
    record2 = store.createRecord 'mip-capture-calculation'
    record2.set 'dna_amount_per_reaction', 20
    mipsRequired = record2.get 'mips_amount_required'
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
    
test 'serial dilutions are properly calculated', (assert) ->
  expect 16
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'mip_volume', 0.5
    record1.set 'phosphorylation_reaction_volume', 200
    serialDilutions = record1.get 'serial_dilutions'
    assert.equal serialDilutions.length, 3
    # dilution step 1
    assert.equal serialDilutions[0].step, 1
    assert.equal serialDilutions[0].amount, 1
    assert.equal serialDilutions[0].dilution_from_previous, null
    assert.equal serialDilutions[0].probe_concentration, 0.25
    assert.equal serialDilutions[0].mips_volume_required, 0.0001695024077046549
    # dilution step 2
    assert.equal serialDilutions[1].step, 2
    assert.equal serialDilutions[1].amount, 5
    assert.equal serialDilutions[1].dilution_from_previous, 5
    assert.equal serialDilutions[1].probe_concentration, 0.05
    assert.equal serialDilutions[1].mips_volume_required, 0.0008475120385232744
    # dilution step 3
    assert.equal serialDilutions[2].step, 3
    assert.equal serialDilutions[2].amount, 250
    assert.equal serialDilutions[2].dilution_from_previous, 50
    assert.equal serialDilutions[2].probe_concentration, 0.001
    assert.equal serialDilutions[2].mips_volume_required, 0.04237560192616372
    


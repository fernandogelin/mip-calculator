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
  expect 19
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'mip_volume', 0.5
    serialDilutions = record1.get 'serial_dilutions'
    assert.equal serialDilutions.length, 3
    # dilution step 1
    record1.set 'dilution', 1
    assert.equal serialDilutions[0].step, 1
    assert.equal serialDilutions[0].amount, 1
    assert.equal serialDilutions[0].dilution_from_previous, null
    assert.equal serialDilutions[0].probe_concentration, 0.0125
    assert.equal serialDilutions[0].mips_volume_required, 0.0033900481540930978
    assert.equal record1.get('serial_dilution.mips_volume_required'), 0.0033900481540930978
    # dilution step 2
    record1.set 'dilution', 5
    assert.equal serialDilutions[1].step, 2
    assert.equal serialDilutions[1].amount, 5
    assert.equal serialDilutions[1].dilution_from_previous, 5
    assert.equal serialDilutions[1].probe_concentration, 0.0025
    assert.equal serialDilutions[1].mips_volume_required, 0.01695024077046549
    assert.equal record1.get('serial_dilution.mips_volume_required'), 0.01695024077046549
    # dilution step 3
    record1.set 'dilution', 250
    assert.equal serialDilutions[2].step, 3
    assert.equal serialDilutions[2].amount, 250
    assert.equal serialDilutions[2].dilution_from_previous, 50
    assert.equal serialDilutions[2].probe_concentration, 0.001
    assert.equal serialDilutions[2].mips_volume_required, 0.04237560192616372
    assert.equal record1.get('serial_dilution.mips_volume_required'), 0.04237560192616372

test 'phosphorylation reaction volumes are properly calculated', (assert) ->
  expect 8
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'mip_count', 890
    record1.set 'mip_volume', 0.18
    record1.set 'phosphorylation_reaction_volume', 200
    assert.equal record1.get('phosphorylation_t4_buffer_volume'), 20
    assert.equal record1.get('phosphorylation_t4_pnk_volume'), 14
    assert.equal record1.get('phosphorylation_mips_pool_volume'), 160.2
    assert.equal record1.get('phosphorylation_water_volume'), 5.8

    record1.set 'phosphorylation_reaction_volume', 100
    record1.set 'mip_count', 1000
    record1.set 'mip_volume', 0.5
    assert.equal record1.get('phosphorylation_t4_buffer_volume'), 10
    assert.equal record1.get('phosphorylation_t4_pnk_volume'), 7
    assert.equal record1.get('phosphorylation_mips_pool_volume'), 500
    assert.equal record1.get('phosphorylation_water_volume'), -417

test 'mip capture reaction volumes are properly calculated', (assert) ->
  expect 8
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'mip_volume', 0.5

    assert.equal record1.get('mip_capture_sample_dna'), 0.5
    assert.equal record1.get('mip_capture_reagents'), 24.5
    assert.equal record1.get('serial_dilution.mips_volume_required'), 0.8475120385232745
    assert.equal record1.get('mip_capture_water'), 20.7905

    record1.set 'mip_volume', 0.18
    record1.set 'phosphorylation_reaction_volume', 100
    record1.set 'dna_sample_concentration', 100
    record1.set 'dna_amount_per_reaction', 75
    record1.set 'dilution', 250

    assert.equal record1.get('mip_capture_sample_dna'), 0.75
    assert.equal record1.get('mip_capture_reagents'), 24.25
    assert.equal record1.get('serial_dilution.mips_volume_required'), 0.882825040128411
    assert.equal record1.get('mip_capture_water'), 20.5052

test 'mip capture master mix volume is proberly calculated', (assert) ->
  expect 10
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'sample_count', 16
    record1.set 'mip_volume', 0.5
    record1.set 'phosphorylation_reaction_volume', 200

    assert.equal record1.get('mip_capture_mix_ampligase_buffer'), 52.5
    assert.equal record1.get('mip_capture_mix_dntps'), 0.672
    assert.equal record1.get('mip_capture_mix_klentaq'), 6.72
    assert.equal record1.get('mip_capture_mix_ampligase'), 0.21
    assert.equal record1.get('mip_capture_mix_water'), 436.6005

    record1.set 'sample_count', 100
    record1.set 'mip_volume', 0.18
    record1.set 'phosphorylation_reaction_volume', 100

    assert.equal record1.get('mip_capture_mix_ampligase_buffer'), 262.5
    assert.equal record1.get('mip_capture_mix_dntps'), 3.360000
    assert.equal record1.get('mip_capture_mix_klentaq'), 33.600000
    assert.equal record1.get('mip_capture_mix_ampligase'), 1.050000
    assert.equal record1.get('mip_capture_mix_water'), 2148.3945

test 'exonuclease treatment mix is properly calculated', (assert) ->
  expect 8
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'sample_count', 16
    assert.equal record1.get('exo_treatment_mix_exo1'), 10.5
    assert.equal record1.get('exo_treatment_mix_exo3'), 10.5
    assert.equal record1.get('exo_treatment_mix_ampligase_buffer'), 4.2
    assert.equal record1.get('exo_treatment_mix_water'), 16.8

    record1.set 'sample_count', 100
    assert.equal record1.get('exo_treatment_mix_exo1'), 52.5
    assert.equal record1.get('exo_treatment_mix_exo3'), 52.5
    assert.equal record1.get('exo_treatment_mix_ampligase_buffer'), 21
    assert.equal record1.get('exo_treatment_mix_water'), 84

test 'pcr reaction mix is properly calculated', (assert) ->
  expect 6
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'sample_count', 16
    assert.equal record1.get('pcr_barcoding_mix_iproof'), 262.5
    assert.equal record1.get('pcr_barcoding_mix_fprimer'), 2.625
    assert.equal record1.get('pcr_barcoding_mix_water'), 128.625

    record1.set 'sample_count', 100
    assert.equal record1.get('pcr_barcoding_mix_iproof'), 1312.500
    assert.equal record1.get('pcr_barcoding_mix_fprimer'), 13.125
    assert.equal record1.get('pcr_barcoding_mix_water'), 643.125

test 'library dilution is properly calculated', (assert) ->
  expect 5
  store = @store()
  Ember.run ->
    record1 = store.createRecord 'mip-capture-calculation'
    record1.set 'qubit_read', 0.734
    assert.equal record1.get('library_concentration_required_converted'), 0.3432
    assert.equal record1.get('dilution_library_volume'), 7.01
    assert.equal record1.get('dilution_water_volume'), 7.99

    record1.set 'qubit_read', 2
    assert.equal record1.get('dilution_library_volume'), 2.57
    assert.equal record1.get('dilution_water_volume'), 12.43

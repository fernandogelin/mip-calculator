`import DS from 'ember-data'`

MipCaptureCalculation = DS.Model.extend
  name: DS.attr 'string'
  date_created: DS.attr 'date', defaultValue: -> new Date

  mip_concentration: DS.attr 'number', defaultValue: 5 #µM
  dna_sample_concentration: DS.attr 'number', defaultValue: 200 #ng/µL

  sample_count: DS.attr 'number', defaultValue: 16

  phosphorylation_reaction_volume: DS.attr 'number', defaultValue: 200 #µL

  mip_count: DS.attr 'number', defaultValue: 890
  mip_volume: DS.attr 'number', defaultValue: 0.18 #µL

  dna_amount_per_reaction: DS.attr 'number', defaultValue: 100 #ng
  dna_amount_per_ng: 330
  mip_copy_count_per_genome: 800

  mip_copy_count_required: Ember.computed 'dna_amount_per_reaction', 'dna_amount_per_ng', 'mip_copy_count_per_genome', ->
    @get('dna_amount_per_reaction') *
      @get('dna_amount_per_ng') *
      @get('mip_copy_count_per_genome')

  # pmol
  mips_amount_required: Ember.computed 'mip_copy_count_required', ->
    @get('mip_copy_count_required') /
      (6.23 * Math.pow(10, 11))

  # µM probe
  probe_concentration: Ember.computed 'mip_concentration', 'phosphorylation_reaction_volume', 'mip_volume', ->
    (@get('mip_concentration') * @get('mip_volume')) /
      @get('phosphorylation_reaction_volume')

  dilution: DS.attr 'number', defaultValue: 250
  serial_dilutions: Ember.computed 'probe_concentration', 'mips_amount_required', ->
    dilutions = [1, 5, 250]
    for amount, i in dilutions
      step: i + 1
      amount: amount
      dilution_from_previous: (amount / dilutions[i - 1]) if dilutions[i - 1]
      probe_concentration: @get('probe_concentration') / amount
      # µL
      mips_volume_required: @get('mips_amount_required') /
         (@get('probe_concentration') / amount)
  serial_dilution: Ember.computed 'dilution', 'serial_dilutions', ->
    dilution = @get 'dilution'
    @get('serial_dilutions').findBy 'amount', dilution


  # µL
  phosphorylation_t4_buffer_volume: Ember.computed 'phosphorylation_reaction_volume', ->
    Math.round(@get('phosphorylation_reaction_volume') * 0.1)
  phosphorylation_t4_pnk_volume: Ember.computed 'phosphorylation_reaction_volume', ->
    Math.round(@get('phosphorylation_reaction_volume') * 0.07)
  phosphorylation_mips_pool_volume: Ember.computed 'mip_count', 'mip_volume', ->
    @get('mip_count') *
      @get('mip_volume')
  phosphorylation_water_volume: Ember.computed 'phosphorylation_reaction_volume', 'phosphorylation_t4_buffer_volume', 'phosphorylation_t4_pnk_volume', 'phosphorylation_mips_pool_volume', ->
    volume = @get('phosphorylation_reaction_volume') -
      @get('phosphorylation_t4_buffer_volume') -
      @get('phosphorylation_t4_pnk_volume') -
      @get('phosphorylation_mips_pool_volume')
    Math.round(volume * 100) / 100

  #µL
  mip_capture_ampligase_buffer: 2.5
  mip_capture_dntps: 0.032
  mip_capture_klentaq: 0.32
  mip_capture_ampligase: 0.01
  mip_capture_sample_dna: Ember.computed 'dna_sample_concentration', 'dna_amount_per_reaction', ->
    @get('dna_amount_per_reaction') / @get('dna_sample_concentration')
  mip_capture_reagents: Ember.computed 'mip_capture_sample_dna', ->
    25 - @get('mip_capture_sample_dna')
  mip_capture_water: Ember.computed 'mip_capture_ampligase_buffer', 'mip_capture_dntps', 'mip_capture_klentaq', 'mip_capture_ampligase', 'mip_capture_reagents', 'serial_dilution.mips_volume_required', ->
   volume = @get('mip_capture_reagents') -
     @get('mip_capture_ampligase_buffer') -
     @get('mip_capture_dntps') -
     @get('mip_capture_klentaq') -
     @get('mip_capture_ampligase') -
     @get('serial_dilution.mips_volume_required')
   Math.round(volume * 10000) / 10000

  # mip capture master mix µL
  master_mix_extra: DS.attr 'number', defaultValue: 5
  mip_capture_mix_ampligase_buffer: Ember.computed 'mip_capture_ampligase_buffer', 'sample_count', 'master_mix_extra', ->
    @get('mip_capture_ampligase_buffer') * (@get('sample_count') + @get('master_mix_extra'))
  mip_capture_mix_dntps: Ember.computed 'mip_capture_dntps', 'sample_count', 'master_mix_extra', ->
    @get('mip_capture_dntps') * (@get('sample_count') + @get('master_mix_extra'))
  mip_capture_mix_klentaq: Ember.computed 'mip_capture_klentaq', 'sample_count', 'master_mix_extra', ->
    @get('mip_capture_klentaq') * (@get('sample_count') + @get('master_mix_extra'))
  mip_capture_mix_ampligase: Ember.computed 'mip_capture_ampligase', 'sample_count', 'master_mix_extra', ->
    @get('mip_capture_ampligase') * (@get('sample_count') + @get('master_mix_extra'))
  mip_capture_mix_water: Ember.computed 'mip_capture_water', 'sample_count', 'master_mix_extra', 'master_mix_extra', ->
    @get('mip_capture_water') * (@get('sample_count') + @get('master_mix_extra'))

  # µL exonuclease treatment mix
  exo_treatment_exo1: 0.5
  exo_treatment_exo3: 0.5
  exo_treatment_ampligase_buffer: 0.2
  exo_treatment_water: 0.8

  exo_treatment_mix_exo1: Ember.computed 'exo_treatment_exo1', 'sample_count', 'master_mix_extra', ->
    @get('exo_treatment_exo1') * (@get('sample_count') + @get('master_mix_extra'))
  exo_treatment_mix_exo3: Ember.computed 'exo_treatment_exo3', 'sample_count', 'master_mix_extra', ->
    @get('exo_treatment_exo3') * (@get('sample_count') + @get('master_mix_extra'))
  exo_treatment_mix_ampligase_buffer: Ember.computed 'exo_treatment_ampligase_buffer', 'sample_count', 'master_mix_extra', ->
    @get('exo_treatment_ampligase_buffer') * (@get('sample_count') + @get('master_mix_extra'))
  exo_treatment_mix_water: Ember.computed 'exo_treatment_water', 'sample_count', 'master_mix_extra', ->
    @get('exo_treatment_water') * (@get('sample_count') + @get('master_mix_extra'))

  # pcr reagents, µL
  pcr_barcoding_iproof: 12.5
  # 100µM
  pcr_barcoding_fprimer: 0.125
  pcr_barcoding_water: 6.125
  # 10µM
  pcr_barcoding_rprimer: 1.25
  pcr_barcoding_sample: 5

  pcr_barcoding_mix_iproof: Ember.computed 'pcr_barcoding_iproof', 'sample_count', 'master_mix_extra', ->
    @get('pcr_barcoding_iproof') * (@get('sample_count') + @get('master_mix_extra'))
  pcr_barcoding_mix_fprimer: Ember.computed 'pcr_barcoding_fprimer', 'sample_count', 'master_mix_extra', ->
    @get('pcr_barcoding_fprimer') * (@get('sample_count') + @get('master_mix_extra'))
  pcr_barcoding_mix_water: Ember.computed 'pcr_barcoding_water', 'sample_count', 'master_mix_extra', ->
    @get('pcr_barcoding_water') * (@get('sample_count') + @get('master_mix_extra'))

  #library prepareation
  pcr_product_volume: DS.attr 'number', defaultValue: 10 #µL
  pcr_product_pool_volume: Ember.computed 'pcr_product_volume', 'sample_count', ->
    @get('pcr_product_volume') *
      @get('sample_count')
  ampure_beads_volume: Ember.computed 'pcr_product_pool_volume', ->
    @get('pcr_product_pool_volume') * 0.8


  qubit_read: DS.attr 'number' # ng/µL

  library_concentration_required: DS.attr 'number', defaultValue: 2000 #pM
  library_mean_dna_size: DS.attr 'number', defaultValue: 260 #bp
  library_volume_required: DS.attr 'number', defaultValue: 15 #µL

  #ng/µL
  library_concentration_required_converted: Ember.computed 'library_concentration_required', 'library_mean_dna_size', ->
    concentration = @get('library_concentration_required') *
      @get('library_mean_dna_size') * Math.pow(10, -9) * 660
    Math.round(concentration * 10000) / 10000

  dilution_library_volume: Ember.computed 'library_volume_required', 'library_concentration_required_converted', 'qubit_read', ->
    volume = @get('library_volume_required') *
      @get('library_concentration_required_converted') /
      @get('qubit_read')
    Math.round(volume * 100) / 100

  dilution_water_volume: Ember.computed 'library_volume_required', 'dilution_library_volume', ->
    volume = @get('library_volume_required') - @get('dilution_library_volume')
    Math.round(volume * 100) / 100

`export default MipCaptureCalculation`

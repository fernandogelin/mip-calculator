`import DS from 'ember-data'`

MipCaptureCalculation = DS.Model.extend
  name: DS.attr 'string'
  date_created: DS.attr 'date', defaultValue: -> new Date

  mip_concentration: DS.attr 'number', defaultValue: 100 #µM
  dna_sample_concentration: DS.attr 'number', defaultValue: 200 #ng/µL
  
  sample_count: DS.attr 'number'
  
  phosphorylation_reaction_volume: DS.attr 'number' #µL
  
  mip_count: DS.attr 'number'
  mip_volume: DS.attr 'number' #µL
  
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
  mip_capture_mix_ampligase_buffer: Ember.computed 'mip_capture_ampligase_buffer', 'sample_count', ->
    @get('mip_capture_ampligase_buffer') * (@get('sample_count') + 5)
  mip_capture_mix_dntps: Ember.computed 'mip_capture_dntps', 'sample_count', ->
    @get('mip_capture_dntps') * (@get('sample_count') + 5)
  mip_capture_mix_klentaq: Ember.computed 'mip_capture_klentaq', 'sample_count', ->
    @get('mip_capture_klentaq') * (@get('sample_count') + 5)
  mip_capture_mix_ampligase: Ember.computed 'mip_capture_ampligase', 'sample_count', ->
    @get('mip_capture_ampligase') * (@get('sample_count') + 5)
  mip_capture_mix_water: Ember.computed 'mip_capture_water', 'sample_count', ->
    @get('mip_capture_water') * (@get('sample_count') + 5)
      
  

`export default MipCaptureCalculation`

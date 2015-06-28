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
      
  #pmol
  mips_required: Ember.computed 'mip_copy_count_required', -> 
    @get('mip_copy_count_required') /
      (6.23 * Math.pow(10, 11))
      
  # µM probe
  probe_concentration: Ember.computed 'mip_concentration', 'phosphorylation_reaction_volume', 'mip_volume', -> 
    (@get('mip_concentration') * @get('mip_volume')) /
      @get('phosphorylation_reaction_volume')
  

`export default MipCaptureCalculation`

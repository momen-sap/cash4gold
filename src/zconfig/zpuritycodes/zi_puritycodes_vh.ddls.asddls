@AbapCatalog.viewEnhancementCategory: [#NONE]

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'Value Help for Gold Purity Codes'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.representativeKey: 'PurityCode'

@ObjectModel.dataCategory: #VALUE_HELP

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel : { resultSet.sizeCategory: #XS }

@Search.searchable: true

define view entity ZI_PurityCodes_VH  as select from zpuritycodes

  association [0..*] to ZI_PurityCodeText as _Text on $projection.PurityCode = _Text.Puritycode

{
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_Text'
      @UI.textArrangement: #TEXT_LAST
  key puritycode as PurityCode,

      _Text

}

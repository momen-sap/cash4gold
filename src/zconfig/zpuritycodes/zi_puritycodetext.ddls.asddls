@EndUserText.label: 'Purity Codes Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT

@Search.searchable: true

define view entity ZI_PurityCodeText
  as select from zpuritycodestxt
  association [1..1] to ZI_PurityCodeALL_S   as _PurityCodeALL on $projection.SingletonID = _PurityCodeALL.SingletonID
  association        to parent ZI_PurityCode as _PurityCode    on $projection.Puritycode = _PurityCode.Puritycode
  association [0..*] to I_LanguageText       as _LanguageText  on $projection.Langu = _LanguageText.LanguageCode
{
      @Semantics.language: true
  key langu                 as Langu,

  key puritycode            as Puritycode,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.9
      description           as Description,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      1                     as SingletonID,

      _PurityCodeALL,
      _PurityCode,
      _LanguageText

}

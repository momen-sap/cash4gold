@EndUserText.label: 'Purity Code'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_PurityCode
  as select from ZPURITYCODES
  association to parent ZI_PurityCodeALL_S as _PurityCodeALL on $projection.SingletonID = _PurityCodeALL.SingletonID
  composition [0..*] of ZI_PurityCodeText as _PurityCodeText
{
  key PURITYCODE as Puritycode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  1 as SingletonID,
  _PurityCodeALL,
  _PurityCodeText
  
}

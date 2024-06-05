@EndUserText.label: 'Purity Code - Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_PurityCode
  as projection on ZI_PurityCode
{
  key Puritycode,
  @Consumption.hidden: true
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _PurityCodeALL : redirected to parent ZC_PurityCodeALL_S,
  _PurityCodeText : redirected to composition child ZC_PurityCodeText,
  _PurityCodeText.Description : localized
  
}

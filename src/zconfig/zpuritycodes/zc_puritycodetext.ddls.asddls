@EndUserText.label: 'Purity Codes Text - Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_PurityCodeText
  as projection on ZI_PurityCodeText
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Langu,
  key Puritycode,
  Description,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _PurityCode : redirected to parent ZC_PurityCode,
  _PurityCodeALL : redirected to ZC_PurityCodeALL_S
  
}

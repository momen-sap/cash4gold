@EndUserText.label: 'Purity Codes All Singleton - Maintain'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_PurityCodeALL_S
  provider contract transactional_query
  as projection on ZI_PurityCodeALL_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _PurityCode : redirected to composition child ZC_PurityCode
  
}

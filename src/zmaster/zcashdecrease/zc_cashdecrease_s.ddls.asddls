@EndUserText.label: 'Projection cashdecrease singleton entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['SingletonID']

define root view entity ZC_CASHDECREASE_S
  provider contract transactional_query
  as projection on ZI_CashDecrease_S
{
  key SingletonID,

      @Consumption.hidden: true
      LastChangedAtMax,
      /* Associations */
      _CashDecrease : redirected to composition child ZC_CASHDECREASE
}

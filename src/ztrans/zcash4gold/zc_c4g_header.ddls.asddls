@EndUserText.label: 'Projection C4G Header'
@AccessControl.authorizationCheck: #CHECK

@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZC_C4G_HEADER
  as projection on ZI_C4G_Header
{

  key HeaderUuid,

      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      HeaderId,

      StoreNumber,

      @EndUserText.label: 'Weight Uom'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure'} }]
      HeaderUom,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
      HeaderCurrencyCode,

      @EndUserText.label: 'Gold Price / 1g'
      @EndUserText.quickInfo: 'Gold Price per 1g as of the transaction Changed On Date'
      @Semantics.amount.currencyCode: 'HeaderCurrencyCode'
      GoldPriceByDate,

      @EndUserText.label: 'Seller Full Name'
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.7
      SellerFullname,

      @EndUserText.label: 'Seller Email'
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.7
      SellerEmail,

      @EndUserText.label: 'Total Cash'
      @Semantics.amount.currencyCode: 'HeaderCurrencyCode'
      HeaderTotalCash,

      @EndUserText.label: 'Note'
      HeaderNote,

      @ObjectModel.text.element: ['HeaderStatusTxt']
      HeaderStatus,

      @Semantics.text: true
      _DomainText.text as HeaderStatusTxt,

      @ObjectModel.text.element: ['PersonFullName']
      LastChangedBy,

      _UserTxt.PersonFullName,

      @Consumption.hidden: true
      LastChangedAt,

      LocalLastChangedAt,

      /* Associations */
      _Items : redirected to composition child ZC_C4G_Item
}

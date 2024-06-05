@EndUserText.label: 'Projection C4G Item'
@AccessControl.authorizationCheck: #CHECK

@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZC_C4G_Item
  as projection on ZI_C4G_Item
{

  key ItemUuid,

      HeaderUuid,

      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      ItemNumber,

      @EndUserText.label: 'Item Description'
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.7
      ItemName,
      
      @Semantics.imageUrl: true
      Attachment,
      MimeType,
      Filename,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_PurityCodes_VH', element: 'PurityCode'}, useForValidation: true }]
      @ObjectModel.text.element: ['PurityCodeText']
      ItemPurityCode,

      _PurityTextbySysLang.Description as PurityCodeText,

      @Semantics.quantity.unitOfMeasure: 'CashDecreaseUom'
      CashDecrease,

      @EndUserText.label: 'Percent'
      CashDecreaseUom,

      @EndUserText.label: 'Item Weight'
      @Semantics.quantity.unitOfMeasure: 'ItemUom'
      ItemWeight,

      @EndUserText.label: 'Weight Uom'
      ItemUom,

      @EndUserText.label: 'Item Cash'
      @Semantics.amount.currencyCode: 'ItemCurrencyCode'
      ItemCash,

      ItemCurrencyCode,

      LocalLastChangedAt,

      /* Associations */
      _Header : redirected to parent ZC_C4G_HEADER
}

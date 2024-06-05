@EndUserText.label: 'Projection cash decrease entity'
@AccessControl.authorizationCheck: #CHECK

@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['StoreNumber', 'PurityCode']

define view entity ZC_CASHDECREASE
  as projection on ZI_CashDecrease
{

  key StoreNumber,

      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_PurityCodes_VH', element: 'PurityCode' }, useForValidation: true }]
      @ObjectModel.text.element: ['PurityCodeText']
  key PurityCode,

      _PurityTextbySysLang.Description as PurityCodeText,

      @Consumption.hidden: true
      SingletonID,

      @Semantics.quantity.unitOfMeasure: 'DecreaseUom'
      CashDecrease,

      DecreaseUom,

      //LocalCreatedBy,

      //LocalCreatedAt,

      @ObjectModel.text.element: ['PersonFullName']
      LocalLastChangedBy,

      _UserTxt.PersonFullName,


      LocalLastChangedAt,

      @Consumption.hidden: true
      LastChangedAt,

      /* Associations */
      _Singleton : redirected to parent ZC_CASHDECREASE_S

}

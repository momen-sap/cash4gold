@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cash Decrease by Purity Code Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #M,
    dataClass: #MASTER
}
define view entity ZI_CashDecrease
  as select from zcashdecrease
  
  association to parent ZI_CashDecrease_S as _Singleton on $projection.SingletonID = _Singleton.SingletonID
  
  association [0..1] to ZI_PurityCodeText as _PurityTextbySysLang on $projection.PurityCode = _PurityTextbySysLang.Puritycode and _PurityTextbySysLang.Langu = $session.system_language
  
  association [0..1] to I_BusinessUserVH as _UserTxt on $projection.LocalLastChangedBy = _UserTxt.UserID
{
  key store_number          as StoreNumber,

  key purity_code            as PurityCode,

      1                     as SingletonID,

      @Semantics.quantity.unitOfMeasure: 'DecreaseUom'
      cash_decrease         as CashDecrease,
      
      decrease_uom          as DecreaseUom,

      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,

      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,

      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

      //local etag field --> odata etag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      //total etag field
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      
      /* Associations */
      _Singleton,
      
      _PurityTextbySysLang,
      
      _UserTxt
}

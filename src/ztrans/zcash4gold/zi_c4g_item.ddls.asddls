@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'C4G Item'
define view entity ZI_C4G_Item
  as select from zc4g_item

  association        to parent ZI_C4G_Header as _Header              on  $projection.HeaderUuid = _Header.HeaderUuid

  association [0..1] to ZI_PurityCodeText    as _PurityTextbySysLang on  $projection.ItemPurityCode = _PurityTextbySysLang.Puritycode
                                                                     and _PurityTextbySysLang.Langu = $session.system_language

{
  key item_uuid             as ItemUuid,

      header_uuid           as HeaderUuid,

      item_number           as ItemNumber,

      item_name             as ItemName,

      @Semantics.largeObject:
      { mimeType: 'MimeType',
      fileName: 'Filename',
      contentDispositionPreference: #INLINE }
      attachment            as Attachment,
      @Semantics.mimeType: true
      mimetype              as MimeType,
      filename              as Filename,

      item_purity_code      as ItemPurityCode,

      @Semantics.quantity.unitOfMeasure: 'CashDecreaseUom'
      cash_decrease         as CashDecrease,

      cash_decrease_uom     as CashDecreaseUom,

      @Semantics.quantity.unitOfMeasure: 'ItemUom'
      item_weight           as ItemWeight,

      item_uom              as ItemUom,

      @Semantics.amount.currencyCode: 'ItemCurrencyCode'
      item_cash             as ItemCash,

      item_currency_code    as ItemCurrencyCode,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Header, // Make association public

      _PurityTextbySysLang
}

@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'C4G Header'

define root view entity ZI_C4G_Header
  as select from zc4g_header
  composition [0..*] of ZI_C4G_Item      as _Items

  association [0..1] to ZI_C4GSTATUS_TXT as _DomainText on $projection.HeaderStatus = _DomainText.value_low

  association [0..1] to I_BusinessUserVH as _UserTxt    on $projection.LastChangedBy = _UserTxt.UserID
{

  key header_uuid           as HeaderUuid,

      header_id             as HeaderId,

      store_number          as StoreNumber,

      header_uom            as HeaderUom,

      header_currency_code  as HeaderCurrencyCode,

      @Semantics.amount.currencyCode: 'HeaderCurrencyCode'
      gold_price_by_date    as GoldPriceByDate,

      seller_fullname       as SellerFullname,

      seller_email          as SellerEmail,

      @Semantics.amount.currencyCode: 'HeaderCurrencyCode'
      header_total_cash     as HeaderTotalCash,

      header_note           as HeaderNote,

      header_status         as HeaderStatus,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Items, // Make association public

      _DomainText,

      _UserTxt
}

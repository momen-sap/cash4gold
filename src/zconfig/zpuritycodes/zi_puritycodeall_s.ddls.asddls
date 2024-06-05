@EndUserText.label: 'Purity Codes All Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_PurityCodeALL_S
  as select from I_Language
    left outer join ZPURITYCODES on 0 = 0
  composition [0..*] of ZI_PurityCode as _PurityCode
{
  key 1 as SingletonID,
  _PurityCode,
  max( ZPURITYCODES.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language

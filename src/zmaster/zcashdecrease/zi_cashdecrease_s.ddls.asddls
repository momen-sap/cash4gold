@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Singleton Root Entity for Cash Decreas'
define root view entity ZI_CashDecrease_S
  as select from    I_Language
    left outer join zcashdecrease as CashDecreaseTable on 0 = 0

  composition [0..*] of ZI_CashDecrease as _CashDecrease
{

  key 1                                       as SingletonID,

      max (CashDecreaseTable.last_changed_at) as LastChangedAtMax,

      _CashDecrease // Make association public
}
where I_Language.Language = $session.system_language

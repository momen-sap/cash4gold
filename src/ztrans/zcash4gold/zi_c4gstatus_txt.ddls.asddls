@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for status text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel : { resultSet.sizeCategory: #XS }

define view entity ZI_C4GSTATUS_TXT
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(p_domain_name:'ZC4GSTATUS') as _domain
{

  key domain_name,
  key value_position,
  key language,
      value_low,
      text

}
where
  language = $session.system_language

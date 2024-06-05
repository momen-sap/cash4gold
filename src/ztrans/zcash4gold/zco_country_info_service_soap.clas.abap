class ZCO_COUNTRY_INFO_SERVICE_SOAP definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods LIST_OF_LANGUAGES_BY_NAME
    importing
      !INPUT type ZLIST_OF_LANGUAGES_BY_NAME_SO1
    exporting
      !OUTPUT type ZLIST_OF_LANGUAGES_BY_NAME_SOA
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_LANGUAGES_BY_CODE
    importing
      !INPUT type ZLIST_OF_LANGUAGES_BY_CODE_SO1
    exporting
      !OUTPUT type ZLIST_OF_LANGUAGES_BY_CODE_SOA
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CURRENCIES_BY_NAME
    importing
      !INPUT type ZLIST_OF_CURRENCIES_BY_NAME_S1
    exporting
      !OUTPUT type ZLIST_OF_CURRENCIES_BY_NAME_SO
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CURRENCIES_BY_CODE
    importing
      !INPUT type ZLIST_OF_CURRENCIES_BY_CODE_S1
    exporting
      !OUTPUT type ZLIST_OF_CURRENCIES_BY_CODE_SO
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_GROUPED
    importing
      !INPUT type ZLIST_OF_COUNTRY_NAMES_GROUPE1
    exporting
      !OUTPUT type ZLIST_OF_COUNTRY_NAMES_GROUPED
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_BY_NAME
    importing
      !INPUT type ZLIST_OF_COUNTRY_NAMES_BY_NAM1
    exporting
      !OUTPUT type ZLIST_OF_COUNTRY_NAMES_BY_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_BY_CODE
    importing
      !INPUT type ZLIST_OF_COUNTRY_NAMES_BY_COD1
    exporting
      !OUTPUT type ZLIST_OF_COUNTRY_NAMES_BY_CODE
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CONTINENTS_BY_NAME
    importing
      !INPUT type ZLIST_OF_CONTINENTS_BY_NAME_S1
    exporting
      !OUTPUT type ZLIST_OF_CONTINENTS_BY_NAME_SO
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CONTINENTS_BY_CODE
    importing
      !INPUT type ZLIST_OF_CONTINENTS_BY_CODE_S1
    exporting
      !OUTPUT type ZLIST_OF_CONTINENTS_BY_CODE_SO
    raising
      CX_AI_SYSTEM_FAULT .
  methods LANGUAGE_NAME
    importing
      !INPUT type ZLANGUAGE_NAME_SOAP_REQUEST
    exporting
      !OUTPUT type ZLANGUAGE_NAME_SOAP_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods LANGUAGE_ISOCODE
    importing
      !INPUT type ZLANGUAGE_ISOCODE_SOAP_REQUEST
    exporting
      !OUTPUT type ZLANGUAGE_ISOCODE_SOAP_RESPONS
    raising
      CX_AI_SYSTEM_FAULT .
  methods FULL_COUNTRY_INFO_ALL_COUNTRIE
    importing
      !INPUT type ZFULL_COUNTRY_INFO_ALL_COUNTR1
    exporting
      !OUTPUT type ZFULL_COUNTRY_INFO_ALL_COUNTRI
    raising
      CX_AI_SYSTEM_FAULT .
  methods FULL_COUNTRY_INFO
    importing
      !INPUT type ZFULL_COUNTRY_INFO_SOAP_REQUES
    exporting
      !OUTPUT type ZFULL_COUNTRY_INFO_SOAP_RESPON
    raising
      CX_AI_SYSTEM_FAULT .
  methods CURRENCY_NAME
    importing
      !INPUT type ZCURRENCY_NAME_SOAP_REQUEST
    exporting
      !OUTPUT type ZCURRENCY_NAME_SOAP_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_NAME
    importing
      !INPUT type ZCOUNTRY_NAME_SOAP_REQUEST
    exporting
      !OUTPUT type ZCOUNTRY_NAME_SOAP_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_ISOCODE
    importing
      !INPUT type ZCOUNTRY_ISOCODE_SOAP_REQUEST
    exporting
      !OUTPUT type ZCOUNTRY_ISOCODE_SOAP_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_INT_PHONE_CODE
    importing
      !INPUT type ZCOUNTRY_INT_PHONE_CODE_SOAP_1
    exporting
      !OUTPUT type ZCOUNTRY_INT_PHONE_CODE_SOAP_R
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_FLAG
    importing
      !INPUT type ZCOUNTRY_FLAG_SOAP_REQUEST
    exporting
      !OUTPUT type ZCOUNTRY_FLAG_SOAP_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_CURRENCY
    importing
      !INPUT type ZCOUNTRY_CURRENCY_SOAP_REQUEST
    exporting
      !OUTPUT type ZCOUNTRY_CURRENCY_SOAP_RESPONS
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRIES_USING_CURRENCY
    importing
      !INPUT type ZCOUNTRIES_USING_CURRENCY_SOA1
    exporting
      !OUTPUT type ZCOUNTRIES_USING_CURRENCY_SOAP
    raising
      CX_AI_SYSTEM_FAULT .
  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods CAPITAL_CITY
    importing
      !INPUT type ZCAPITAL_CITY_SOAP_REQUEST
    exporting
      !OUTPUT type ZCAPITAL_CITY_SOAP_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCO_COUNTRY_INFO_SERVICE_SOAP IMPLEMENTATION.


  method CAPITAL_CITY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CAPITAL_CITY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_COUNTRY_INFO_SERVICE_SOAP'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method COUNTRIES_USING_CURRENCY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRIES_USING_CURRENCY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_CURRENCY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_CURRENCY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_FLAG.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_FLAG'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_INT_PHONE_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_INT_PHONE_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_ISOCODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_ISOCODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CURRENCY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CURRENCY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method FULL_COUNTRY_INFO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FULL_COUNTRY_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method FULL_COUNTRY_INFO_ALL_COUNTRIE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FULL_COUNTRY_INFO_ALL_COUNTRIE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LANGUAGE_ISOCODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LANGUAGE_ISOCODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LANGUAGE_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LANGUAGE_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CONTINENTS_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CONTINENTS_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CONTINENTS_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CONTINENTS_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_GROUPED.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_GROUPED'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CURRENCIES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CURRENCIES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CURRENCIES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CURRENCIES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_LANGUAGES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_LANGUAGES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_LANGUAGES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_LANGUAGES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.

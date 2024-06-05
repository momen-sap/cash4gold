CLASS zcl_call_soap_srv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CALL_SOAP_SRV IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.

        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = 'http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso' ).

        DATA(proxy) = NEW zco_country_info_service_soap(
          destination = destination
        ).
        DATA(request) = VALUE zcountry_currency_soap_request( s_country_isocode = 'US' ).
        proxy->country_currency(
          EXPORTING
            input  = request
          IMPORTING
            output = DATA(response)
        ).

        out->write( response-country_currency_result-s_name ).

        "handle response
      CATCH cx_soap_destination_error.
        "handle error
      CATCH cx_ai_system_fault.
        "handle error
    ENDTRY.


  ENDMETHOD.
ENDCLASS.

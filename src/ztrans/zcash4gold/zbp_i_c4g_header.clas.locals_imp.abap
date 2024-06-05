CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS approve FOR MODIFY
      IMPORTING keys FOR ACTION header~approve RESULT result.

    METHODS recalctotalprice FOR MODIFY
      IMPORTING keys FOR ACTION header~recalctotalprice.

    METHODS reject FOR MODIFY
      IMPORTING keys FOR ACTION header~reject RESULT result.

    METHODS setinitialstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR header~setinitialstatus.

    METHODS setstorenumber FOR DETERMINE ON MODIFY
      IMPORTING keys FOR header~setstorenumber.

    METHODS settodaygoldprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR header~settodaygoldprice.

    METHODS calculateheaderid FOR DETERMINE ON SAVE
      IMPORTING keys FOR header~calculateheaderid.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~validatecurrencycode.

    METHODS validateemail FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~validateemail.

    METHODS validateuom FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~validateuom.

    METHODS readtodaygoldprice IMPORTING currency TYPE waers weightuom TYPE msehi RETURNING VALUE(goldprice) TYPE zc4gamount.

    METHODS is_update_granted RETURNING VALUE(update_granted) TYPE abap_bool.

    METHODS is_delete_granted   RETURNING VALUE(delete_granted) TYPE abap_bool.

    METHODS is_create_granted RETURNING VALUE(create_granted) TYPE abap_bool.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_features.

    " Read
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        FIELDS ( headerstatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      FAILED failed.

    result =
      VALUE #(
        FOR header IN lt_headers
          LET lv_approved =   COND #( WHEN header-headerstatus = 'A'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              lv_rejected =   COND #( WHEN header-headerstatus = 'X'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = header-%tky
              %action-approve = lv_approved
              %action-reject = lv_rejected
             ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

    " Read
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        FIELDS ( headerstatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      FAILED failed.

    CHECK lt_headers IS NOT INITIAL.

    DATA(is_update_requested) = COND #( WHEN requested_authorizations-%update              = if_abap_behv=>mk-on OR
                                       requested_authorizations-%action-approve = if_abap_behv=>mk-on OR
                                       requested_authorizations-%action-reject = if_abap_behv=>mk-on OR
                                       requested_authorizations-%action-edit         = if_abap_behv=>mk-on
                                  THEN abap_true ELSE abap_false ).

    DATA(is_delete_requested) = COND #( WHEN requested_authorizations-%delete = if_abap_behv=>mk-on
                                    THEN abap_true ELSE abap_false ).

    LOOP AT lt_headers INTO DATA(ls_header).

      IF is_update_requested = abap_true.
        DATA(update_granted) = is_update_granted( ).
        IF update_granted = abap_false.
          APPEND VALUE #( %tky        = ls_header-%tky
                          %msg        = NEW zcx_c4g( severity = if_abap_behv_message=>severity-error
                                                          textid   = zcx_c4g=>unauthorized )
                        ) TO reported-header.
        ENDIF.
      ENDIF.

      IF is_delete_requested = abap_true.
        DATA(delete_granted) = is_delete_granted( ).
        IF delete_granted = abap_false.
          APPEND VALUE #( %tky        = ls_header-%tky
                          %msg        = NEW zcx_c4g( severity = if_abap_behv_message=>severity-error
                                                          textid   = zcx_c4g=>unauthorized )
                        ) TO reported-header.
        ENDIF.
      ENDIF.

      APPEND VALUE #( %tky = ls_header-%tky
                     %action-approve = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                     %action-reject = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                     %action-edit         = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                     %update              = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                     %delete              = COND #( WHEN delete_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )

                   )
       TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD approve.

    " Set the new overall status
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
         UPDATE
           FIELDS ( headerstatus )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             headerstatus = 'A' ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    result = VALUE #( FOR header IN lt_headers
                        ( %tky   = header-%tky
                          %param = header ) ).

  ENDMETHOD.

  METHOD recalctotalprice.

    TYPES: BEGIN OF ty_amount_per_currencycode,
             amount        TYPE zc4gamount,
             currency_code TYPE waers,
           END OF ty_amount_per_currencycode.

    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.
    DATA: converted_amount_per_curr TYPE zc4gamount.

    " Read all relevant headers instances.
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
          ENTITY header
             FIELDS (  headercurrencycode )
             WITH CORRESPONDING #( keys )
          RESULT DATA(lt_headers).

    DELETE lt_headers WHERE headercurrencycode IS INITIAL.

    LOOP AT lt_headers ASSIGNING FIELD-SYMBOL(<header>).
      " Set the start for the calculation by adding initial
      amount_per_currencycode = VALUE #( ( amount        = 0
                                           currency_code = <header>-headercurrencycode ) ).

      " Read all associated items and add them to the total cash.
      READ ENTITIES OF zi_c4g_header IN LOCAL MODE
         ENTITY header BY \_items
            FIELDS ( itemcash itemcurrencycode )
          WITH VALUE #( ( %tky = <header>-%tky ) )
          RESULT DATA(lt_items).


      LOOP AT lt_items INTO DATA(ls_item) WHERE itemcurrencycode IS NOT INITIAL.
        COLLECT VALUE ty_amount_per_currencycode( amount        = ls_item-itemcash
                                                  currency_code = ls_item-itemcurrencycode ) INTO amount_per_currencycode.
      ENDLOOP.

      CLEAR <header>-headertotalcash.


      LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).
        " If needed do a Currency Conversion
        IF single_amount_per_currencycode-currency_code = <header>-headercurrencycode.
          <header>-headertotalcash += single_amount_per_currencycode-amount.
        ELSE.
          TRY.
              cl_exchange_rates=>convert_to_local_currency(
                EXPORTING
                  date             = cl_abap_context_info=>get_system_date( )
                  foreign_amount   = single_amount_per_currencycode-amount
                  foreign_currency = single_amount_per_currencycode-currency_code
                  local_currency   = <header>-headercurrencycode
                IMPORTING
                  local_amount     = converted_amount_per_curr
              ).

              <header>-headertotalcash += converted_amount_per_curr.

            CATCH cx_exchange_rates INTO DATA(ex_rate).
              "
          ENDTRY.
        ENDIF.
      ENDLOOP.

    ENDLOOP.


    " write back the modified total_price of headers
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        UPDATE FIELDS ( headertotalcash )
        WITH CORRESPONDING #( lt_headers ).

  ENDMETHOD.

  METHOD reject.

    " Set the new overall status
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
         UPDATE
           FIELDS ( headerstatus )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             headerstatus = 'X' ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    result = VALUE #( FOR header IN lt_headers
                        ( %tky   = header-%tky
                          %param = header ) ).

  ENDMETHOD.

  METHOD setinitialstatus.

    " Read relevant instance data
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
        ENTITY header
          FIELDS ( headerstatus )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_headers).

    " Remove all instance data with defined value
    DELETE lt_headers WHERE headerstatus IS NOT INITIAL.
    CHECK lt_headers IS NOT INITIAL.

    " write back the modified fields
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        UPDATE FIELDS ( headerstatus )
        WITH VALUE #( FOR ls_header IN lt_headers
                      ( %tky         = ls_header-%tky
                        headerstatus = 'O' ) )
        REPORTED DATA(modified_reported).

    " fill the determination (changing parameter) reported.
    reported = CORRESPONDING #( DEEP modified_reported ).

  ENDMETHOD.

  METHOD setstorenumber.

    " Read relevant instance data
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
        ENTITY header
          FIELDS ( storenumber )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_headers).

    " Remove all instance data with defined value
    DELETE lt_headers WHERE storenumber IS NOT INITIAL.
    CHECK lt_headers IS NOT INITIAL.

    " write back the modified fields
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        UPDATE FIELDS ( storenumber )
        WITH VALUE #( FOR ls_header IN lt_headers
                      ( %tky         = ls_header-%tky
                        storenumber = '001' ) )
        REPORTED DATA(modified_reported).

    " fill the determination (changing parameter) reported.
    reported = CORRESPONDING #( DEEP modified_reported ).

  ENDMETHOD.

  METHOD settodaygoldprice.

    " Read relevant instance data
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
        ENTITY header
          FIELDS ( goldpricebydate )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_headers).

    " determine gold price for each header based on Weight Uom and Currency
    LOOP AT lt_headers ASSIGNING FIELD-SYMBOL(<ls_header>).
      DATA(todaygoldprice) = me->readtodaygoldprice( currency = <ls_header>-headercurrencycode weightuom = <ls_header>-headeruom ). " Get Today Gold Price
      <ls_header>-goldpricebydate = todaygoldprice.
    ENDLOOP.


    " write back the modified fields
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        UPDATE FIELDS ( goldpricebydate )
        WITH CORRESPONDING #( lt_headers )
        REPORTED DATA(modified_reported).

    " fill the determination (changing parameter) reported.
    reported = CORRESPONDING #( DEEP modified_reported ).

  ENDMETHOD.

  METHOD calculateheaderid.

    " Please note that this is just an example for calculating a field during _onSave_.
    " This approach does NOT ensure for gap free or unique travel IDs! It just helps to provide a readable ID.
    " The key of this business object is a UUID, calculated by the framework.

    " check if ID is already filled
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
      ENTITY header
        FIELDS ( headerid ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    " remove lines where  ID is already filled.
    DELETE lt_headers WHERE headerid IS NOT INITIAL.

    " anything left ?
    CHECK lt_headers IS NOT INITIAL.

    " Select max travel ID
    SELECT SINGLE
        FROM  zc4g_header
        FIELDS MAX( header_id ) AS headerid
        INTO @DATA(max_headerid).

    " Set the travel ID
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY header
      UPDATE
        FROM VALUE #( FOR header IN lt_headers INDEX INTO i (
          %tky              = header-%tky
          headerid          = max_headerid + i
          %control-headerid = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD validatecurrencycode.

    " read instances
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
       ENTITY header
         FIELDS ( headercurrencycode ) WITH CORRESPONDING #( keys )
       RESULT DATA(lt_headers).

    " loop and validate each header
    LOOP AT lt_headers ASSIGNING FIELD-SYMBOL(<ls_header>).

      APPEND VALUE #( %tky        = <ls_header>-%tky
                       %state_area = 'VALIDATE_CURRENCY'
                     ) TO reported-header.

      IF <ls_header>-headercurrencycode <> 'USD'.
        APPEND VALUE #( %tky = <ls_header>-%tky ) TO failed-header.

        APPEND VALUE #( %tky                        = <ls_header>-%tky
                        %state_area = 'VALIDATE_CURRENCY'
                        %msg = NEW zcx_c4g( textid =  zcx_c4g=>currencycode_invalid
                                                     severity = if_abap_behv_message=>severity-error
                                                     currencycode = <ls_header>-headercurrencycode
                                                     )
                        %element-headercurrencycode = if_abap_behv=>mk-on
                      ) TO reported-header.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateemail.

    " read instances
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
       ENTITY header
         FIELDS ( selleremail ) WITH CORRESPONDING #( keys )
       RESULT DATA(lt_headers).

    " loop and validate each header

    "DATA c_mailpattern TYPE c LENGTH 60 VALUE '[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4} '.

    LOOP AT lt_headers ASSIGNING FIELD-SYMBOL(<ls_header>).

      APPEND VALUE #( %tky        = <ls_header>-%tky
                       %state_area = 'VALIDATE_EMAIL'
                     ) TO reported-header.

      "FIND PCRE c_mailpattern IN <ls_header>-selleremail IGNORING CASE .

      FIND ALL OCCURRENCES OF '@' IN <ls_header>-selleremail MATCH COUNT DATA(v_count).
      IF v_count <> 1.
        " invalid format


        APPEND VALUE #( %tky = <ls_header>-%tky ) TO failed-header.

        APPEND VALUE #( %tky                        = <ls_header>-%tky
                        %state_area = 'VALIDATE_EMAIL'
                        %msg = NEW zcx_c4g( textid =  zcx_c4g=>email_invalid
                                                     severity = if_abap_behv_message=>severity-error
                                                     )
                        %element-selleremail = if_abap_behv=>mk-on
                      ) TO reported-header.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD validateuom.

    " read instances
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
       ENTITY header
         FIELDS ( headeruom ) WITH CORRESPONDING #( keys )
       RESULT DATA(lt_headers).

    " loop and validate each header
    LOOP AT lt_headers ASSIGNING FIELD-SYMBOL(<ls_header>).

      APPEND VALUE #( %tky        = <ls_header>-%tky
                       %state_area = 'VALIDATE_HEADER_UOM'
                     ) TO reported-header.

      IF <ls_header>-headeruom <> 'G'.
        APPEND VALUE #( %tky = <ls_header>-%tky ) TO failed-header.

        APPEND VALUE #( %tky                        = <ls_header>-%tky
                        %state_area = 'VALIDATE_HEADER_UOM'
                        %msg = NEW zcx_c4g( textid =  zcx_c4g=>headeruom_invalid
                                                     severity = if_abap_behv_message=>severity-error
                                                     headeruom = <ls_header>-headeruom
                                                     )
                        %element-headeruom = if_abap_behv=>mk-on
                      ) TO reported-header.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD readtodaygoldprice.
    IF currency IS NOT INITIAL AND weightuom IS NOT INITIAL.
      " TODO: read from external service API
*      DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = 'http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso' ).
*
*        DATA(proxy) = NEW zco_country_info_service_soap(
*          destination = destination
*        ).
*        DATA(request) = VALUE zcountry_currency_soap_request( s_country_isocode = 'US' ).
*        proxy->country_currency(
*          EXPORTING
*            input  = request
*          IMPORTING
*            output = DATA(response)
*        ).

      goldprice = '53.35'.
    ELSE.
      goldprice = 0.
    ENDIF.
  ENDMETHOD.


  METHOD is_create_granted.

    AUTHORITY-CHECK OBJECT 'ZAOC4G'
      ID 'ZAFC4G' DUMMY
      ID 'ACTVT' FIELD '01'.

    create_granted = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).

    " Simulate full access - for testing purposes only! Needs to be removed for a productive implementation.
    " create_granted = abap_true.

  ENDMETHOD.


  METHOD is_delete_granted.


    AUTHORITY-CHECK OBJECT 'ZAOC4G'
     ID 'ZAFC4G' DUMMY
     ID 'ACTVT' FIELD '06'.

    delete_granted = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).

    " Simulate full access - for testing purposes only! Needs to be removed for a productive implementation.
    " delete_granted = abap_true.

  ENDMETHOD.

  METHOD is_update_granted.

    AUTHORITY-CHECK OBJECT 'ZAOC4G'
      ID 'ZAFC4G' DUMMY
      ID 'ACTVT' FIELD '02'.

    update_granted = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).

    " Simulate full access - for testing purposes only! Needs to be removed for a productive implementation.
    " update_granted = abap_true.

  ENDMETHOD.


ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateitemcash FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~calculateitemcash.

    METHODS calculateitemnumber FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~calculateitemnumber.

    METHODS setcashdecrease FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~setcashdecrease.

    METHODS setitemuom FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~setitemuom.

    METHODS validateitemweight FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~validateitemweight.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD calculateitemcash.

    DATA update TYPE TABLE FOR UPDATE zi_c4g_header\\item.

    DATA: lv_cash_by_gold_price TYPE zc4gamount,
          lv_cash_reduce        TYPE zc4gamount,
          lv_cash               TYPE zc4gamount.

    " Read all headers for the requested items.
    " If multiple items of the same Header are requested, the Header is returned only once.
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item BY \_header
      FIELDS ( goldpricebydate headercurrencycode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    " Process all affected Headers. Read respective items.
    LOOP AT lt_headers INTO DATA(ls_header).
      READ ENTITIES OF zi_c4g_header IN LOCAL MODE
        ENTITY header BY \_items
          FIELDS ( cashdecrease itemweight )
        WITH VALUE #( ( %tky = ls_header-%tky ) )
        RESULT DATA(lt_items).

      " Provide a CashDEcrease for all items
      LOOP AT lt_items INTO DATA(ls_item).

        lv_cash_by_gold_price = ls_item-itemweight * ls_header-goldpricebydate.
        lv_cash_reduce = ls_item-itemweight * ls_header-goldpricebydate * ( ls_item-cashdecrease / 100 ).
        lv_cash = lv_cash_by_gold_price - lv_cash_reduce.

        APPEND VALUE #( %tky      = ls_item-%tky
              itemcash = lv_cash
              itemcurrencycode = ls_header-headercurrencycode
            ) TO update.

      ENDLOOP.
    ENDLOOP.

    " Update the item Cash of all relevant items
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item
      UPDATE FIELDS ( itemcash itemcurrencycode ) WITH update
    REPORTED DATA(update_reported).

    "Then after all items cash was calculated then calculate the header.

    " Trigger calculation of the header total cash
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY header
      EXECUTE recalctotalprice
      FROM CORRESPONDING #( lt_headers )
    REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).

  ENDMETHOD.

  METHOD calculateitemnumber.

    DATA max_item_number TYPE zitemno.
    DATA update TYPE TABLE FOR UPDATE zi_c4g_header\\item.

    " Read all headers for the requested items.
    " If multiple items of the same Header are requested, the Header is returned only once.
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item BY \_header
      FIELDS ( headeruuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    " Process all affected Headers. Read respective items, determine the max-id and update the items without ID.
    LOOP AT lt_headers INTO DATA(ls_header).
      READ ENTITIES OF zi_c4g_header IN LOCAL MODE
        ENTITY header BY \_items
          FIELDS ( itemnumber )
        WITH VALUE #( ( %tky = ls_header-%tky ) )
        RESULT DATA(lt_items).

      " Find max used ItemNumber in all Items of this Header
      max_item_number ='0000'.
      LOOP AT lt_items INTO DATA(ls_item).
        IF ls_item-itemnumber > max_item_number.
          max_item_number = ls_item-itemnumber.
        ENDIF.
      ENDLOOP.

      " Provide a ItemNumber for all items that have none.
      LOOP AT lt_items INTO ls_item WHERE itemnumber IS INITIAL.
        max_item_number += 10.
        APPEND VALUE #( %tky      = ls_item-%tky
                        itemnumber = max_item_number
                      ) TO update.
      ENDLOOP.
    ENDLOOP.

    " Update the ItemID of all relevant items
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item
      UPDATE FIELDS ( itemnumber ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD setcashdecrease.

    DATA update TYPE TABLE FOR UPDATE zi_c4g_header\\item.

    " Read all headers for the requested items.
    " If multiple items of the same Header are requested, the Header is returned only once.
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item BY \_header
      FIELDS ( storenumber )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).


    " Process all affected Headers. Read respective items, determine the cash decrease.
    LOOP AT lt_headers INTO DATA(ls_header).

      READ ENTITIES OF zi_c4g_header IN LOCAL MODE
             ENTITY header BY \_items
               FIELDS ( itempuritycode )
             WITH VALUE #( ( %tky = ls_header-%tky ) )
             RESULT DATA(lt_items).


      " Provide a CashDEcrease for all items
      LOOP AT lt_items INTO DATA(ls_item).

        IF ls_header-storenumber IS NOT INITIAL AND ls_item-itempuritycode IS NOT INITIAL.

          SELECT SINGLE FROM zi_cashdecrease FIELDS cashdecrease, decreaseuom
          WHERE storenumber = @ls_header-storenumber AND puritycode = @ls_item-itempuritycode
          INTO (@DATA(lv_cashdecrease), @DATA(lv_decreaseuom)).

          IF sy-subrc = 0.

            APPEND VALUE #( %tky      = ls_item-%tky
                            cashdecrease = lv_cashdecrease
                            cashdecreaseuom = lv_decreaseuom
                          ) TO update.

          ELSE.
            APPEND VALUE #( %tky      = ls_item-%tky
              cashdecrease = 0
              cashdecreaseuom = '%'
            ) TO update.
          ENDIF.

        ELSE.

          APPEND VALUE #( %tky      = ls_item-%tky
            cashdecrease = 0
            cashdecreaseuom = '%'
          ) TO update.

        ENDIF.
      ENDLOOP.

    ENDLOOP.

    " Update the ItemID of all relevant items
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item
      UPDATE FIELDS ( cashdecrease cashdecreaseuom ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD setitemuom.

    DATA update TYPE TABLE FOR UPDATE zi_c4g_header\\item.

    " Read all headers for the requested items.
    " If multiple items of the same Header are requested, the Header is returned only once.
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item BY \_header
      FIELDS ( headeruom )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    " Process all affected Headers. Read respective items, determine the item weight uom.
    LOOP AT lt_headers INTO DATA(ls_header).

      READ ENTITIES OF zi_c4g_header IN LOCAL MODE
             ENTITY header BY \_items
               FIELDS ( itemuom )
             WITH VALUE #( ( %tky = ls_header-%tky ) )
             RESULT DATA(lt_items).

      " Provide a item weight uom for all items that have none.
      LOOP AT lt_items INTO DATA(ls_item) WHERE itemuom IS INITIAL.

        APPEND VALUE #( %tky      = ls_item-%tky
                        itemuom = ls_header-headeruom
                      ) TO update.
      ENDLOOP.

    ENDLOOP.

    " Update the item weight uom of all relevant items
    MODIFY ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item
      UPDATE FIELDS ( itemuom ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.


  METHOD validateitemweight.

    " Read all headers for the requested items.
    " If multiple items of the same Header are requested, the Header is returned only once.
    READ ENTITIES OF zi_c4g_header IN LOCAL MODE
    ENTITY item BY \_header
      FIELDS ( headeruuid )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers).

    " Process all affected Headers. Read respective items.
    LOOP AT lt_headers INTO DATA(ls_header).

      READ ENTITIES OF zi_c4g_header IN LOCAL MODE
             ENTITY header BY \_items
               FIELDS ( itemweight )
             WITH VALUE #( ( %tky = ls_header-%tky ) )
             RESULT DATA(lt_items).

      LOOP AT lt_items INTO DATA(ls_item).

        " Item reported
        APPEND VALUE #( %tky        = ls_item-%tky
                         %state_area = 'VALIDATE_ITEM_WEIGHT'
                       ) TO reported-item.

        IF ls_item-itemweight NOT BETWEEN 0 AND 3000.

          " the item error itself
          APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.

          APPEND VALUE #( %tky                        = ls_item-%tky
                          %state_area = 'VALIDATE_ITEM_WEIGHT'
                          %msg = NEW zcx_c4g( textid =  zcx_c4g=>item_weight_invalid
                                              severity = if_abap_behv_message=>severity-error
                                )
                          %element-itemweight = if_abap_behv=>mk-on
                          %path-header-%tky = ls_header-%tky
                        ) TO reported-item.

        ENDIF.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

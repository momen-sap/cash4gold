CLASS lhc_cashdecreasesingleton DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR cashdecreasesingleton RESULT result.

ENDCLASS.

CLASS lhc_cashdecreasesingleton IMPLEMENTATION.

  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_CASHDECREASE' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%update      = is_authorized.
    result-%action-edit = is_authorized.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_cashdecrease DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS defaultuomtopercentage FOR DETERMINE ON MODIFY
      IMPORTING keys FOR cashdecrease~defaultuomtopercentage.

    METHODS validatecashdecrease FOR VALIDATE ON SAVE
      IMPORTING keys FOR cashdecrease~validatecashdecrease.
    METHODS validatepuritycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR cashdecrease~validatepuritycode.

ENDCLASS.

CLASS lhc_cashdecrease IMPLEMENTATION.

  METHOD defaultuomtopercentage.

    " Read relevant (CashDecrease) instance data
    READ ENTITIES OF zi_cashdecrease_s IN LOCAL MODE
        ENTITY cashdecrease
          FIELDS ( singletonid decreaseuom )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cashdecrease).

    " default CashDecreaseUOM to percentage (%)
    LOOP AT lt_cashdecrease ASSIGNING FIELD-SYMBOL(<ls_cashdecrease>).
      IF <ls_cashdecrease>-decreaseuom IS INITIAL.
        <ls_cashdecrease>-decreaseuom = '%'.
      ENDIF.
    ENDLOOP.


    " write back the modified CashDecreaseUOM
    MODIFY ENTITIES OF zi_cashdecrease_s IN LOCAL MODE
      ENTITY cashdecrease
        UPDATE FIELDS ( decreaseuom )
        WITH CORRESPONDING #( lt_cashdecrease )
        REPORTED DATA(modified_uom_reported).

    " fill the determination (changing parameter) reported.
    reported = CORRESPONDING #( DEEP modified_uom_reported ).

  ENDMETHOD.

  METHOD validatecashdecrease.

    " Read relevant (CashDecrease) instance data
    READ ENTITIES OF zi_cashdecrease_s IN LOCAL MODE
        ENTITY cashdecrease
          FIELDS ( singletonid cashdecrease )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cashdecrease).


    " Raise message for CashDecrease field of each entity if:
    " - empty
    " - less than 0
    " - more than 100
    LOOP AT lt_cashdecrease ASSIGNING FIELD-SYMBOL(<ls_cashdecrease>).

      APPEND VALUE #( %tky        = <ls_cashdecrease>-%tky
                      %state_area = 'VALIDATE_CASH_DECREASE'
                    ) TO reported-cashdecrease.

*      IF <ls_cashdecrease>-cashdecrease IS INITIAL.
*        APPEND VALUE #( %tky = <ls_cashdecrease>-%tky ) TO failed-cashdecrease.
*
*        APPEND VALUE #( %tky = <ls_cashdecrease>-%tky
*                        %msg = NEW zcx_cashdecrease( textid =  zcx_cashdecrease=>cashdecrease_required
*                                                     severity = if_abap_behv_message=>severity-error
*                                                     cashdecrease = <ls_cashdecrease>-cashdecrease )
*                        %element-cashdecrease = if_abap_behv=>mk-on
*                        %state_area = 'VALIDATE_CASH_DECREASE'
*                        %path-cashdecreasesingleton = CORRESPONDING #( <ls_cashdecrease> )
*                      ) TO reported-cashdecrease.

      IF <ls_cashdecrease>-cashdecrease NOT BETWEEN 0 AND 100.
        APPEND VALUE #( %tky  = <ls_cashdecrease>-%tky ) TO failed-cashdecrease.

        APPEND VALUE #( %tky = <ls_cashdecrease>-%tky
                        %msg = NEW zcx_cashdecrease( textid =  zcx_cashdecrease=>cashdecrease_invalid
                                                     severity = if_abap_behv_message=>severity-error
                                                     cashdecrease = <ls_cashdecrease>-cashdecrease )
                        %element-cashdecrease = if_abap_behv=>mk-on
                        %state_area = 'VALIDATE_CASH_DECREASE'
                        %path-cashdecreasesingleton = CORRESPONDING #( <ls_cashdecrease> )
                      ) TO reported-cashdecrease.

      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD validatepuritycode.

    " Read relevant (CashDecrease) instance data
    READ ENTITIES OF zi_cashdecrease_s IN LOCAL MODE
        ENTITY cashdecrease
          FIELDS ( singletonid puritycode )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cashdecrease).

    " remove duplicated codes for faster read from ZI_PurityCode
    DATA purity_codes TYPE SORTED TABLE OF zpuritycodes WITH UNIQUE KEY puritycode.
    purity_codes = CORRESPONDING #( lt_cashdecrease DISCARDING DUPLICATES MAPPING puritycode = puritycode EXCEPT * ).

    " find valid codes
    IF purity_codes IS NOT INITIAL.
      SELECT FROM zpuritycodes FIELDS puritycode
        FOR ALL ENTRIES IN @purity_codes
        WHERE puritycode = @purity_codes-puritycode
        INTO TABLE @DATA(lt_purity_codes).
    ENDIF.

    " Raise message for PurityCode field if not valid
    LOOP AT lt_cashdecrease ASSIGNING FIELD-SYMBOL(<ls_cashdecrease>).

      APPEND VALUE #( %tky        = <ls_cashdecrease>-%tky
                       %state_area = 'VALIDATE_PURITY_CODE'
                     ) TO reported-cashdecrease.

      IF NOT line_exists( lt_purity_codes[ puritycode = <ls_cashdecrease>-puritycode ] ).
        APPEND VALUE #( %tky = <ls_cashdecrease>-%tky ) TO failed-cashdecrease.

        APPEND VALUE #( %tky                        = <ls_cashdecrease>-%tky
                        %msg = NEW zcx_cashdecrease( textid =  zcx_cashdecrease=>puritycode_invalid
                                                     severity = if_abap_behv_message=>severity-error
                                                     puritycode = <ls_cashdecrease>-puritycode )
                        %element-cashdecrease = if_abap_behv=>mk-on
                        %state_area = 'VALIDATE_PURITY_CODE'
                        %path-cashdecreasesingleton = CORRESPONDING #( <ls_cashdecrease> )
                      ) TO reported-cashdecrease.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_cashdecrease_s DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_cashdecrease_s IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

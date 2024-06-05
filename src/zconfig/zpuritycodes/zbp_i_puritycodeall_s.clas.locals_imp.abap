CLASS LHC_RAP_TDAT_CTS DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TABLE_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                         ( entity = 'PurityCode' table = 'ZPURITYCODES' )
                                         ( entity = 'PurityCodeText' table = 'ZPURITYCODESTXT' )
                                       ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PURITYCODEALL_S DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR PurityCodeALL
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION PurityCodeALL~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR PurityCodeALL
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_PURITYCODEALL_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = 'ZPURITYCODES'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
                                iv_objectname = 'ZPURITYCODES'
                                iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_PurityCodeALL_S IN LOCAL MODE
    ENTITY PurityCodeALL
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_PurityCode = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_PurityCodeALL_S IN LOCAL MODE
      ENTITY PurityCodeALL
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_PurityCodeALL_S IN LOCAL MODE
      ENTITY PurityCodeALL
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_PURITYCODE' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_PURITYCODEALL_S DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_PURITYCODEALL_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-PurityCodeALL INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PURITYCODE DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATERECORDCHANGES FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR PurityCode~ValidateRecordChanges,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR PurityCode
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_PURITYCODE IMPLEMENTATION.
  METHOD VALIDATERECORDCHANGES.
    DATA change TYPE REQUEST FOR CHANGE ZI_PurityCodeALL_S.
    SELECT SINGLE TransportRequestID FROM ZPURITYCODES_D_S INTO @DATA(TransportRequestID). "#EC CI_NOORDER
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZPURITYCODES'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-PurityCode ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZPURITYCODES'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
    result-%ASSOC-_PurityCodeText = edit_flag.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PURITYCODETEXT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATERECORDCHANGES FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR PurityCodeText~ValidateRecordChanges,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR PurityCodeText
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_PURITYCODETEXT IMPLEMENTATION.
  METHOD VALIDATERECORDCHANGES.
    DATA change TYPE REQUEST FOR CHANGE ZI_PurityCodeALL_S.
    SELECT SINGLE TransportRequestID FROM ZPURITYCODES_D_S INTO @DATA(TransportRequestID). "#EC CI_NOORDER
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = TransportRequestID
                                table             = 'ZPURITYCODESTXT'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-PurityCodeText ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZPURITYCODESTXT'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.

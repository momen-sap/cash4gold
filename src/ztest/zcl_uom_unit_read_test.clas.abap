CLASS zcl_uom_unit_read_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_UOM_UNIT_READ_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lo_uom  TYPE REF TO cl_uom_maintenance,
          ls_unit TYPE cl_uom_maintenance=>ty_uom_ts.

    cl_uom_maintenance=>get_instance(
      RECEIVING
        ro_uom = lo_uom ).

    TRY.
        "Unit found
        lo_uom->read( EXPORTING unit    = '%'
                      IMPORTING unit_st = ls_unit
                               ).
      CATCH cx_uom_error.
    ENDTRY.
    out->write( ls_unit-unit ).
    out->write( ls_unit-commercial ).
    out->write( ls_unit-technical ).
    out->write( ls_unit-dimid ).

  ENDMETHOD.
ENDCLASS.

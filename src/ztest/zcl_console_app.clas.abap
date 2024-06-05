CLASS zcl_console_app DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    METHODS draw IMPORTING lv_number TYPE i DEFAULT 7 RETURNING VALUE(longstring) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CONSOLE_APP IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    out->write( |     Hello World ! \n ({ cl_abap_context_info=>get_user_formatted_name( ) })| ).

    out->write( me->draw( lv_number = 11 ) ).

    out->write( |\n ABAP Pascal Triangle :)| ).

  ENDMETHOD.


  METHOD draw.

    DATA: a TYPE i VALUE 1,
          b TYPE i VALUE 1,
          c TYPE i.

    WHILE a <= lv_number.

      c = lv_number - a.
      b = 1.

      longstring = longstring && |\n|.

      WHILE b <= c.
        longstring = longstring && | |.
        b = b + 1.
      ENDWHILE.

      WHILE b < lv_number.
        longstring = longstring && |*|.
        b = b + 1.
      ENDWHILE.

      WHILE c < lv_number.
        longstring = longstring && |*|.
        c = c + 1.
      ENDWHILE.

      a = a + 1.

    ENDWHILE.

  ENDMETHOD.
ENDCLASS.

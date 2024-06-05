CLASS zcx_cashdecrease DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_abap_behv_message.

    CONSTANTS:
      BEGIN OF cashdecrease_required,
        msgid TYPE symsgid VALUE 'ZMSG_CASHDECREASE',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'cashdecrease',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF cashdecrease_required,
      BEGIN OF cashdecrease_invalid,
        msgid TYPE symsgid VALUE 'ZMSG_CASHDECREASE',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'cashdecrease',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF cashdecrease_invalid,
      BEGIN OF puritycode_invalid,
        msgid TYPE symsgid VALUE 'ZMSG_CASHDECREASE',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'puritycode',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF puritycode_invalid.


    DATA cashdecrease TYPE zdecreaspercentage READ-ONLY.

    DATA puritycode TYPE zpuritycode READ-ONLY.

    METHODS constructor
      IMPORTING
        textid       LIKE if_t100_message=>t100key OPTIONAL
        previous     LIKE previous OPTIONAL
        severity     TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        cashdecrease TYPE zdecreaspercentage OPTIONAL
        puritycode   TYPE zpuritycode OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_CASHDECREASE IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->if_abap_behv_message~m_severity = severity.
    me->puritycode = puritycode.
    me->cashdecrease = cashdecrease.

  ENDMETHOD.
ENDCLASS.

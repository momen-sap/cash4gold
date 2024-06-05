CLASS zcx_c4g DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_abap_behv_message.

    CONSTANTS:
      BEGIN OF currencycode_invalid,
        msgid TYPE symsgid VALUE 'ZMSG_C4G',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'currencycode',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF currencycode_invalid,
      BEGIN OF email_invalid,
        msgid TYPE symsgid VALUE 'ZMSG_C4G',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF email_invalid,
      BEGIN OF headeruom_invalid,
        msgid TYPE symsgid VALUE 'ZMSG_C4G',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'headeruom',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF headeruom_invalid,
      BEGIN OF unauthorized,
        msgid TYPE symsgid VALUE 'ZMSG_C4G',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF unauthorized,
      BEGIN OF item_weight_invalid,
        msgid TYPE symsgid VALUE 'ZMSG_C4G',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF item_weight_invalid.

    DATA currencycode TYPE waers READ-ONLY.
    DATA headeruom TYPE msehi READ-ONLY.

    METHODS constructor
      IMPORTING
        !textid      LIKE if_t100_message=>t100key OPTIONAL
        !previous    LIKE previous OPTIONAL
        severity     TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        currencycode TYPE waers OPTIONAL
        headeruom    TYPE msehi OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCX_C4G IMPLEMENTATION.


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
    me->currencycode = currencycode.
    me->headeruom = headeruom.

  ENDMETHOD.
ENDCLASS.

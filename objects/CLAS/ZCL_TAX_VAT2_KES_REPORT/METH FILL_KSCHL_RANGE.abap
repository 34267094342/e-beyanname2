  METHOD fill_kschl_range.

    DATA ls_hesap TYPE mty_hesap.
    DATA lt_hesap TYPE mtty_hesap.

    FIELD-SYMBOLS <fs_range> TYPE any.
    FIELD-SYMBOLS <fs_value> TYPE any.

    lt_hesap = it_hesap.

    me->filter_kschl_from_formul( CHANGING ct_hesap = lt_hesap ).

    SORT lt_hesap BY kschl .
    DELETE ADJACENT DUPLICATES FROM lt_hesap COMPARING kschl.

    LOOP AT lt_hesap INTO ls_hesap.

      APPEND INITIAL LINE TO er_kschl ASSIGNING <fs_range>.
      CHECK <fs_range> IS ASSIGNED.

      ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_range> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = 'I'.
        UNASSIGN <fs_value>.
      ENDIF.

      ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_range> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = 'EQ'.
        UNASSIGN <fs_value>.
      ENDIF.

      ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_range> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = ls_hesap-kschl.
        UNASSIGN <fs_value>.
      ENDIF.

      UNASSIGN <fs_range>.

    ENDLOOP.

  ENDMETHOD.
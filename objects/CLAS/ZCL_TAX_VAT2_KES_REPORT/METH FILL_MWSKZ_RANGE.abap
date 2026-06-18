  METHOD fill_mwskz_range.

    DATA ls_map TYPE mty_map.

    FIELD-SYMBOLS <fs_range> TYPE any.
    FIELD-SYMBOLS <fs_value> TYPE any.

    CLEAR er_mwskz.

    LOOP AT it_map INTO ls_map.

      APPEND INITIAL LINE TO er_mwskz ASSIGNING <fs_range>.
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
        <fs_value> = ls_map-mwskz.
        UNASSIGN <fs_value>.
      ENDIF.
      UNASSIGN <fs_range>.
    ENDLOOP.

    SORT er_mwskz BY sign option low.
    DELETE ADJACENT DUPLICATES FROM er_mwskz COMPARING sign option low.

  ENDMETHOD.
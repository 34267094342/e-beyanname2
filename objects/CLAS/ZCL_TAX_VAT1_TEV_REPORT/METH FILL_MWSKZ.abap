  METHOD fill_mwskz.

    DATA ls_map TYPE mty_map.
    FIELD-SYMBOLS <fs_range> TYPE any.
    FIELD-SYMBOLS <fs_field> TYPE any.


    LOOP AT it_map INTO ls_map WHERE ( kural EQ '003' ).
      APPEND INITIAL LINE TO er_mwskz ASSIGNING <fs_range>.
      IF <fs_range> IS ASSIGNED.
        ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_range> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = 'I'.
          UNASSIGN <fs_field>.
        ENDIF.
        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_range> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = 'EQ'.
          UNASSIGN <fs_field>.
        ENDIF.
        ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_range> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = ls_map-mwskz.
          UNASSIGN <fs_field>.
        ENDIF.
        UNASSIGN <fs_range>.
      ENDIF.
    ENDLOOP.
    IF sy-subrc IS NOT INITIAL.
      APPEND INITIAL LINE TO er_mwskz ASSIGNING <fs_range>.
      IF <fs_range> IS ASSIGNED.
        ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_range> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = 'I'.
          UNASSIGN <fs_field>.
        ENDIF.
        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_range> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = 'EQ'.
          UNASSIGN <fs_field>.
        ENDIF.
        ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_range> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = '-'.
          UNASSIGN <fs_field>.
        ENDIF.
        UNASSIGN <fs_range>.
      ENDIF.
    ENDIF.

  ENDMETHOD.
  METHOD fill_saknr_range.

    FIELD-SYMBOLS <fs_range> TYPE any.
    FIELD-SYMBOLS <fs_field> TYPE any.
    DATA ls_map TYPE mty_map.
    CLEAR er_saknr.
    LOOP AT it_map INTO ls_map WHERE ( kural EQ '008' OR kural EQ '009' OR kural EQ '010' )
                                 AND saknr NE space.
      APPEND INITIAL LINE TO er_saknr ASSIGNING <fs_range>.
      IF <fs_range> IS ASSIGNED.
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
            <fs_field> = ls_map-saknr.
            UNASSIGN <fs_field>.
          ENDIF.
          UNASSIGN <fs_range>.
        ENDIF.
        UNASSIGN <fs_range>.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
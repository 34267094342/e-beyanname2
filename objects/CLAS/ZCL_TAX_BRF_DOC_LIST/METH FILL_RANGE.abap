  METHOD fill_range.

    FIELD-SYMBOLS <fs_range_line> TYPE any.
    FIELD-SYMBOLS <fs_value> TYPE any.

    APPEND INITIAL LINE TO et_range ASSIGNING <fs_range_line>.
    CHECK <fs_range_line> IS ASSIGNED.

    ASSIGN COMPONENT mc_range_att-sign OF STRUCTURE <fs_range_line> TO <fs_value>.
    IF <fs_value> IS ASSIGNED.
      <fs_value> = iv_sign.
      UNASSIGN <fs_value>.
    ENDIF.

    ASSIGN COMPONENT mc_range_att-option OF STRUCTURE <fs_range_line> TO <fs_value>.
    IF <fs_value> IS ASSIGNED.
      <fs_value> = iv_option.
      UNASSIGN <fs_value>.
    ENDIF.

    ASSIGN COMPONENT mc_range_att-low OF STRUCTURE <fs_range_line> TO <fs_value>.
    IF <fs_value> IS ASSIGNED.
      <fs_value> = iv_low.
      UNASSIGN <fs_value>.
    ENDIF.

    ASSIGN COMPONENT mc_range_att-high OF STRUCTURE <fs_range_line> TO <fs_value>.
    IF <fs_value> IS ASSIGNED.
      <fs_value> = iv_high.
      UNASSIGN <fs_value>.
    ENDIF.

    UNASSIGN <fs_range_line>.

  ENDMETHOD.
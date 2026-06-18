  METHOD fill_det_kural_range.

    FIELD-SYMBOLS <fs_range> TYPE any.
    FIELD-SYMBOLS <fs_value> TYPE any.

    CLEAR mr_kural_det.

    APPEND INITIAL LINE TO mr_kural_det ASSIGNING <fs_range>.
    IF <fs_range> IS ASSIGNED.

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
        <fs_value> = '001'.
        UNASSIGN <fs_value>.
      ENDIF.

      UNASSIGN <fs_range>.
    ENDIF.

    APPEND INITIAL LINE TO mr_kural_det ASSIGNING <fs_range>.
    IF <fs_range> IS ASSIGNED.

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
        <fs_value> = '003'.
        UNASSIGN <fs_value>.
      ENDIF.

      UNASSIGN <fs_range>.
    ENDIF.

    APPEND INITIAL LINE TO mr_kural_det ASSIGNING <fs_range>.
    IF <fs_range> IS ASSIGNED.

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
        <fs_value> = '004'.
        UNASSIGN <fs_value>.
      ENDIF.

      UNASSIGN <fs_range>.
    ENDIF.

    APPEND INITIAL LINE TO mr_kural_det ASSIGNING <fs_range>.
    IF <fs_range> IS ASSIGNED.

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
        <fs_value> = '005'.
        UNASSIGN <fs_value>.
      ENDIF.

      UNASSIGN <fs_range>.
    ENDIF.

    APPEND INITIAL LINE TO mr_kural_det ASSIGNING <fs_range>.
    IF <fs_range> IS ASSIGNED.

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
        <fs_value> = '008'.
        UNASSIGN <fs_value>.
      ENDIF.

      UNASSIGN <fs_range>.
    ENDIF.

    mr_kural_add = mr_kural_det.
    DELETE mr_kural_add WHERE low EQ '005'.

  ENDMETHOD.
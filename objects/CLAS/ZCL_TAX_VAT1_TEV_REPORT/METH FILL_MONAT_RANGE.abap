  METHOD fill_monat_range.
    FIELD-SYMBOLS <fs_monat> TYPE any.
    FIELD-SYMBOLS <fs_field> TYPE any.
    DATA lv_monat TYPE monat.

    CLEAR mr_monat.
    CLEAR lv_monat.
    CLEAR mv_monat.

    CASE p_donemb.
      WHEN '01'.
        APPEND INITIAL LINE TO mr_monat ASSIGNING <fs_monat>.
        ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_monat> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = 'I'.
          UNASSIGN <fs_field>.
        ENDIF.
        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_monat> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = 'EQ'.
          UNASSIGN <fs_field>.
        ENDIF.
        ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_monat> TO <fs_field>.
        IF <fs_field> IS ASSIGNED.
          <fs_field> = p_monat.
          UNASSIGN <fs_field>.
        ENDIF.
        mv_monat = p_monat.
      WHEN '02'.


        DO 3 TIMES.
          lv_monat = lv_monat + 1.
          IF sy-index EQ 1.
            mv_monat = lv_monat.
          ENDIF.
          APPEND INITIAL LINE TO mr_monat ASSIGNING <fs_monat>.
          ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_monat> TO <fs_field>.
          IF <fs_field> IS ASSIGNED.
            <fs_field> = 'I'.
            UNASSIGN <fs_field>.
          ENDIF.
          ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_monat> TO <fs_field>.
          IF <fs_field> IS ASSIGNED.
            <fs_field> = 'EQ'.
            UNASSIGN <fs_field>.
          ENDIF.
          ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_monat> TO <fs_field>.
          IF <fs_field> IS ASSIGNED.
            <fs_field> = lv_monat.
            UNASSIGN <fs_field>.
          ENDIF.
        ENDDO.
    ENDCASE.

  ENDMETHOD.
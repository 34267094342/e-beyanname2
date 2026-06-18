  METHOD get_prev_balance.

    FIELD-SYMBOLS <fs_range> TYPE any.
    FIELD-SYMBOLS <fs_field> TYPE any.

    DATA lv_monat TYPE i_journalentry-fiscalperiod.

    READ TABLE mr_monat ASSIGNING <fs_range> INDEX 1.
    IF <fs_range> IS ASSIGNED.
      ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_range> TO <fs_field>.
      IF <fs_field> IS ASSIGNED.
        lv_monat = <fs_field>.
        UNASSIGN <fs_field>.
      ENDIF.
      UNASSIGN <fs_range>.
    ENDIF.

    SELECT SUM( wrbtr )
           FROM ztax_t_thlog
           WHERE bukrs EQ @p_bukrs
             AND gjahr EQ @p_gjahr
             AND monat LT @lv_monat
            INTO @ev_balance.

  ENDMETHOD.
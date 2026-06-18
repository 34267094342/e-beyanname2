  METHOD fill_period.

    DATA lv_fiscyearper TYPE i_journalentryitem-fiscalyearperiod."acdoca-fiscyearper.
    DATA lv_sign(1).
    DATA lv_option(2).

    FIELD-SYMBOLS <fs_line>    TYPE any.
    FIELD-SYMBOLS <fs_val>     TYPE any.

    LOOP AT ir_monat ASSIGNING <fs_line>.

      CLEAR lv_sign.
      CLEAR lv_option.
      CLEAR lv_fiscyearper.

      ASSIGN COMPONENT mc_range_att-sign OF STRUCTURE <fs_line> TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        lv_sign = <fs_val>.
        UNASSIGN <fs_val>.
      ENDIF.

      ASSIGN COMPONENT mc_range_att-option OF STRUCTURE <fs_line> TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        lv_option = <fs_val>.
        UNASSIGN <fs_val>.
      ENDIF.

      ASSIGN COMPONENT mc_range_att-low OF STRUCTURE <fs_line> TO <fs_val>.
      IF <fs_val> IS ASSIGNED.
        CONCATENATE p_gjahr
                    '0'
                    <fs_val>
                    INTO lv_fiscyearper.

        UNASSIGN <fs_val>.
      ENDIF.

      me->fill_range( EXPORTING iv_sign   = lv_sign
                                iv_option = lv_option
                                iv_low    = lv_fiscyearper
                      IMPORTING et_range  = er_fiscyearper ).

    ENDLOOP.

  ENDMETHOD.
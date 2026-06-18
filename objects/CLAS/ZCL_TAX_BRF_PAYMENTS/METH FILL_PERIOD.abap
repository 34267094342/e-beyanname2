  METHOD fill_period.


    DATA lv_fiscyearper TYPE fis_jahrper_conv.
    DATA lv_sign TYPE string.
    DATA lv_option TYPE string.

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
  METHOD change_formul_for_abap.

    DATA ls_hes TYPE mty_hes.
    DATA lt_hes TYPE TABLE OF  mty_hes.
    DATA lv_hesaptip TYPE ztax_t_k2hes-hesaptip.

    SELECT hesaptip,
           hesap
           FROM ztax_t_k2hes
           INTO TABLE @lt_hes.

    DO 5 TIMES.
      CLEAR lv_hesaptip.
      lv_hesaptip = sy-index.

      CLEAR ls_hes.
      READ TABLE lt_hes INTO ls_hes WITH KEY hesaptip = lv_hesaptip.
      IF sy-subrc IS INITIAL.
        me->hesap( IMPORTING et_hesap = et_hesap
                   CHANGING  cs_hes   = ls_hes ).
      ENDIF.

    ENDDO.

  ENDMETHOD.
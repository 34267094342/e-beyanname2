  METHOD hesap.
    DATA lv_found_index TYPE i.
    DATA lv_index       TYPE i.
    DATA lv_length      TYPE i.
    DATA ls_hesap       TYPE mty_hesap.

    CONDENSE cs_hes-hesap NO-GAPS.
    IF cs_hes-hesap NE space.
      DO strlen( cs_hes-hesap ) TIMES.
        lv_index = sy-index - 1.
        CASE cs_hes-hesap+lv_index(1).
          WHEN '+' OR '-' OR '(' OR ')' OR '/' OR '*'.
            IF lv_index EQ 0.
              lv_found_index = sy-index.
              ls_hesap-sign  = cs_hes-hesap+lv_index(1).
              CONTINUE.
            ENDIF.
            lv_length = sy-index - lv_found_index - 1.
            IF lv_length EQ 0.
              ls_hesap-hesaptip = cs_hes-hesaptip.
              APPEND ls_hesap TO et_hesap.
            ELSE.
              ls_hesap-kschl =  cs_hes-hesap+lv_found_index(lv_length).
            ENDIF.
            IF ls_hesap-kschl IS NOT INITIAL.
              ls_hesap-hesaptip = cs_hes-hesaptip.
              APPEND ls_hesap TO et_hesap.
            ENDIF.
            lv_found_index = sy-index .
            CLEAR ls_hesap.
            IF lv_found_index NE 1.
              ls_hesap-sign =  cs_hes-hesap+lv_index(1).
            ENDIF.
        ENDCASE.
      ENDDO.
      ls_hesap-kschl    = cs_hes-hesap+lv_found_index(*).
      ls_hesap-hesaptip = cs_hes-hesaptip.
      APPEND ls_hesap TO et_hesap.
      CLEAR ls_hesap.
    ENDIF.

  ENDMETHOD.
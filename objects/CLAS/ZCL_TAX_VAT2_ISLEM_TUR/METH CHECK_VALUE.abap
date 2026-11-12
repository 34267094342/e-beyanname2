  METHOD check_value.

    DATA lv_value TYPE string.
    DATA lv_type  TYPE string.

    CLEAR ev_islem_tur.
    ev_valid = abap_false.

    lv_value = iv_value.
    CONDENSE lv_value.
    IF lv_value IS INITIAL.
      RETURN.
    ENDIF.

    "Metin olarak karşılaştır: '20260926' gibi bir Tayin değeri
    "sayısal dönüşümle yanlışlıkla bir işlem türüne eşlenmesin.
    LOOP AT mt_ist INTO DATA(ls_ist) WHERE mwskz = iv_mwskz.
      lv_type = ls_ist-k2type.
      CONDENSE lv_type.
      IF lv_type = lv_value.
        ev_islem_tur = ls_ist-k2type.
        ev_valid     = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
  METHOD determine.

    DATA ls_result   TYPE ty_result.
    DATA lt_distinct TYPE tt_distinct.
    DATA lv_type     TYPE ty_islem_tur.
    DATA lv_valid    TYPE abap_bool.
    DATA lv_found    TYPE abap_bool.
    DATA lv_pos      TYPE i.
    DATA lv_count    TYPE i.
    DATA lv_index    TYPE i.

    CLEAR ev_islem_tur.
    ev_source = c_source_not_relevant.

    ls_result-bukrs = iv_bukrs.
    ls_result-belnr = iv_belnr.
    ls_result-gjahr = iv_gjahr.
    ls_result-mwskz = iv_mwskz.
    ls_result-buzei = iv_taxitem.

    READ TABLE mt_result INTO DATA(ls_buffer) WITH TABLE KEY bukrs = ls_result-bukrs
                                                             belnr = ls_result-belnr
                                                             gjahr = ls_result-gjahr
                                                             mwskz = ls_result-mwskz
                                                             buzei = ls_result-buzei.
    IF sy-subrc IS INITIAL.
      ev_islem_tur = ls_buffer-islem_tur.
      ev_source    = ls_buffer-source.
      RETURN.
    ENDIF.

    "Vergi kodu işlem türü tablosunda yoksa KDV2 konusu değil
    READ TABLE mt_ist TRANSPORTING NO FIELDS WITH KEY mwskz = iv_mwskz.
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    "Vergi satırının, belge + vergi kodu içindeki sırası
    LOOP AT mt_taxitem INTO DATA(ls_taxitem) WHERE bukrs = iv_bukrs
                                               AND belnr = iv_belnr
                                               AND gjahr = iv_gjahr
                                               AND mwskz = iv_mwskz.
      lv_count = lv_count + 1.
      IF ls_taxitem-buzei = ls_result-buzei.
        lv_pos = lv_count.
        EXIT.
      ENDIF.
    ENDLOOP.

    "1) Vergi kalemleri: önce aynı sıradaki kalem, yoksa tüm vergi
    "   kalemlerinde tek bir geçerli değer varsa o
    LOOP AT mt_item INTO DATA(ls_item) WHERE bukrs = iv_bukrs
                                         AND belnr = iv_belnr
                                         AND gjahr = iv_gjahr
                                         AND buzid = 'T'
                                         AND mwskz = iv_mwskz.
      lv_index = lv_index + 1.
      me->check_value( EXPORTING iv_mwskz     = iv_mwskz
                                 iv_value     = ls_item-value
                       IMPORTING ev_islem_tur = lv_type
                                 ev_valid     = lv_valid ).
      CHECK lv_valid EQ abap_true.
      IF lv_index EQ lv_pos.
        ls_result-islem_tur = lv_type.
        ls_result-source    = c_source_tax_line.
        lv_found            = abap_true.
        EXIT.
      ENDIF.
      INSERT lv_type INTO TABLE lt_distinct.
    ENDLOOP.

    IF lv_found EQ abap_false AND lines( lt_distinct ) EQ 1.
      READ TABLE lt_distinct INTO ls_result-islem_tur INDEX 1.
      ls_result-source = c_source_tax_line.
      lv_found         = abap_true.
    ENDIF.

    "2) Aynı vergi kodlu gider kalemleri (satıcı kalemi hariç)
    IF lv_found EQ abap_false.
      CLEAR lt_distinct.
      LOOP AT mt_item INTO ls_item WHERE bukrs = iv_bukrs
                                     AND belnr = iv_belnr
                                     AND gjahr = iv_gjahr
                                     AND buzid NE 'T'
                                     AND koart NE 'K'
                                     AND mwskz = iv_mwskz.
        me->check_value( EXPORTING iv_mwskz     = iv_mwskz
                                   iv_value     = ls_item-value
                         IMPORTING ev_islem_tur = lv_type
                                   ev_valid     = lv_valid ).
        CHECK lv_valid EQ abap_true.
        INSERT lv_type INTO TABLE lt_distinct.
      ENDLOOP.
      IF lines( lt_distinct ) EQ 1.
        READ TABLE lt_distinct INTO ls_result-islem_tur INDEX 1.
        ls_result-source = c_source_expense_line.
        lv_found         = abap_true.
      ENDIF.
    ENDIF.

    "3) Vergi kodu 'Diğer' dışında tek işlem türüne bağlıysa o
    IF lv_found EQ abap_false.
      CLEAR lt_distinct.
      LOOP AT mt_ist INTO DATA(ls_ist) WHERE mwskz = iv_mwskz.
        CHECK ls_ist-k2type NE c_islem_tur_diger.
        INSERT ls_ist-k2type INTO TABLE lt_distinct.
      ENDLOOP.
      IF lines( lt_distinct ) EQ 1.
        READ TABLE lt_distinct INTO ls_result-islem_tur INDEX 1.
        ls_result-source = c_source_tax_code.
        lv_found         = abap_true.
      ENDIF.
    ENDIF.

    "4) Belirlenemedi
    IF lv_found EQ abap_false.
      CLEAR ls_result-islem_tur.
      ls_result-source = c_source_unresolved.
    ENDIF.

    INSERT ls_result INTO TABLE mt_result.

    ev_islem_tur = ls_result-islem_tur.
    ev_source    = ls_result-source.

  ENDMETHOD.
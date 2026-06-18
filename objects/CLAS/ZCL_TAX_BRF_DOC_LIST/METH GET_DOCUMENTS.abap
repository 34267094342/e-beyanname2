  METHOD get_documents.

    TYPES BEGIN OF lty_lfa1.
    TYPES lifnr TYPE i_supplier-supplier.
    TYPES name1 TYPE i_supplier-organizationbpname1.
    TYPES name2 TYPE i_supplier-organizationbpname2.
    TYPES END OF lty_lfa1.

    DATA ls_collect     TYPE mty_collect.
    DATA lt_mg          TYPE mtty_mg.
    DATA lt_mg_range    TYPE mtty_mg.
    DATA lt_data        TYPE mtty_data.
    DATA lt_data_wh     TYPE mtty_data.
    DATA lt_data_k      TYPE mtty_data.
    DATA lt_data_191    TYPE mtty_data_191.
    DATA lt_lfb1        TYPE mtty_lfb1.
    DATA ls_lfb1        TYPE mty_lfb1.
    DATA ls_data        TYPE mty_data.
    DATA ls_mg          TYPE mty_mg.
    DATA ls_detail      TYPE ztax_ddl_i_brf_detail.
    DATA lv_amount_k    TYPE i_glaccountlineitemrawdata-amountincompanycodecurrency.
    DATA lv_amount_191  TYPE i_glaccountlineitemrawdata-amountincompanycodecurrency.
    DATA lv_butxt       TYPE i_companycode-companycodename."t001-butxt.
    DATA lt_mmt         TYPE TABLE OF ztax_t_mmt.
    DATA ls_mmt         TYPE ztax_t_mmt.
    DATA ls_lfa1        TYPE lty_lfa1.
    DATA lt_lfa1        TYPE TABLE OF lty_lfa1.
    DATA lr_hkont       TYPE RANGE OF i_operationalacctgdocitem-glaccount."bseg-hkont.
    FIELD-SYMBOLS <fs_collect>   TYPE mty_collect.
    FIELD-SYMBOLS <fs_data>      TYPE mty_data.
    FIELD-SYMBOLS <fs_data_191>  TYPE mty_data_191.
    FIELD-SYMBOLS <fs_detail>    TYPE ztax_ddl_i_brf_detail.

    CLEAR mt_collect.
    CLEAR mt_detail.
    CLEAR me->ms_button_pushed.

    IF iv_bukrs IS NOT INITIAL.
      p_bukrs = iv_bukrs.
    ENDIF.

    IF iv_gjahr IS NOT INITIAL.
      p_gjahr = iv_gjahr.
    ENDIF.

    IF iv_monat IS NOT INITIAL.
      p_monat = iv_monat.
    ENDIF.

    IF iv_donemb IS NOT INITIAL.
      p_donemb = iv_donemb.
    ENDIF.

    me->ms_button_pushed-bel = abap_true.

    me->get_item_data( IMPORTING et_mg       = lt_mg
                                 et_data     = lt_data
                                 et_data_191 = lt_data_191
                                 et_lfb1     = lt_lfb1 ).

    SORT lt_data BY bukrs gjahr belnr docln.
    DELETE ADJACENT DUPLICATES FROM lt_data COMPARING bukrs gjahr belnr docln. "YiğitcanÖzdemir Sonradan eklendi

    lt_data_k = lt_data.

    CLEAR lt_mg_range[].
    MOVE-CORRESPONDING lt_mg[] TO lt_mg_range[].
    SORT lt_mg_range ASCENDING BY hkont.
    DELETE ADJACENT DUPLICATES FROM lt_mg_range COMPARING hkont.
    CLEAR lr_hkont[].

    lr_hkont = VALUE #( FOR ls_mg_range IN lt_mg_range
                      ( sign   = 'I'
                        option = 'EQ'
                        low    = ls_mg_range-hkont ) ).
*kaldırıldı Çağatay-Sümeyye
*    DELETE lt_data   WHERE racct NOT IN lr_hkont .
*    DELETE lt_data_k WHERE lifnr EQ space AND racct IN lr_hkont.

    SELECT itab~bukrs AS bukrs,
           itab~belnr AS belnr,
           itab~gjahr AS gjahr,
           wh~withholdingtaxtype AS witht,
           wh~withholdingtaxcode AS wt_withcd,
           wh~whldgtaxamtincocodecrcy AS taxamount,
           wh~whldgtaxbaseamtincocodecrcy AS baseamount
    FROM @lt_data AS itab INNER JOIN i_withholdingtaxitem AS wh
               ON wh~companycode EQ  itab~bukrs
               AND wh~accountingdocument EQ itab~belnr
               AND wh~fiscalyear EQ itab~gjahr
*               AND wh~accountingdocumentitem EQ itab~docln
     ORDER BY bukrs , belnr , gjahr , witht
     INTO CORRESPONDING FIELDS OF TABLE @lt_data_wh.
    DELETE ADJACENT DUPLICATES FROM lt_data_wh COMPARING bukrs belnr gjahr witht.


    SORT lt_data_191 BY rbukrs
                        gjahr
                        belnr.

    SORT lt_data_k BY bukrs
                      gjahr
                      belnr.

    SORT lt_data BY bukrs
                    gjahr
                    belnr.




    LOOP AT lt_data INTO ls_data.
      CLEAR ls_collect.
      CLEAR ls_detail.
      CLEAR lv_amount_191.
      CLEAR lv_amount_k.

      "07.07.2025 - Azınlık kırılım düzenlemesi - eğer satıcıya dair azınlık tanımlanmadıysa lt_mgden oku
      "eğer satıcıya dair azınlık tanımlıysa, o değer alınmalı
***      CASE ls_data-lifnr.
***        WHEN space.
***          READ TABLE lt_mg INTO ls_mg WITH KEY bukrs = ls_data-bukrs
***                                               hkont = ls_data-racct
***                                               BINARY SEARCH.
***        WHEN OTHERS.
***          READ TABLE lt_lfb1 INTO ls_lfb1 WITH KEY bukrs = ls_data-bukrs
***                                                   lifnr = ls_data-lifnr
***                                                   BINARY SEARCH.
***
***          READ TABLE lt_mg INTO ls_mg WITH KEY bukrs = ls_data-bukrs
***                                               mindk = ls_lfb1-mindk
***                                               BINARY SEARCH.
***      ENDCASE.
*      READ TABLE lt_data_k ASSIGNING <fs_data> WITH KEY bukrs = ls_data-bukrs
*                                                        gjahr = ls_data-gjahr
*                                                        belnr = ls_data-belnr
*                                                        BINARY SEARCH.
*      IF sy-subrc EQ 0.
      "önce satıcı kodu ile ara
*        READ TABLE lt_lfb1 INTO ls_lfb1 WITH KEY bukrs = ls_data-bukrs
*                                                 lifnr = <fs_data>-lifnr
*                                                 BINARY SEARCH.
*        "satıcıda yoksa, hesaptan genel azınlığa bak
*        IF sy-subrc NE 0.
*          READ TABLE lt_mg INTO ls_mg WITH KEY bukrs = ls_data-bukrs
*                                               hkont = ls_data-racct
*                                               BINARY SEARCH.
*        ELSE.
*eklendi -Çağatay Sümeyye.
      CASE ls_data-witht.
        WHEN 'S1' OR 'S2' OR 'S3' OR 'S4'.
          ls_lfb1-mindk = '22'.
        WHEN 'S8'.
          CASE ls_data-wt_withcd.
            WHEN 'G9'.
              ls_lfb1-mindk = '22'.
            WHEN 'G8'.
              ls_lfb1-mindk = '156'.
          ENDCASE.
        WHEN 'T3' OR 'S7' OR 'T4'.
          ls_lfb1-mindk = '156'.
        WHEN 'S5' OR 'S6'.
          ls_lfb1-mindk = '41'.
        WHEN 'S9'.
          ls_lfb1-mindk = '279'.
        WHEN 'T5' OR 'ST'.
          ls_lfb1-mindk = '281'.
        WHEN 'T2'.
          ls_lfb1-mindk = '61'.
      ENDCASE.
****************
      READ TABLE lt_mg INTO ls_mg WITH KEY bukrs = ls_data-bukrs
                                           mindk = ls_lfb1-mindk.
*        ENDIF.
*      ENDIF.

      CHECK sy-subrc IS INITIAL.

      READ TABLE lt_data_191 TRANSPORTING NO FIELDS WITH KEY rbukrs = ls_data-bukrs
                                                             gjahr  = ls_data-gjahr
                                                             belnr  = ls_data-belnr
                                                             BINARY SEARCH.
      CASE sy-subrc.
        WHEN 0.
          LOOP AT lt_data_191 ASSIGNING <fs_data_191> FROM sy-tabix.
            IF <fs_data_191>-rbukrs NE ls_data-bukrs OR
               <fs_data_191>-gjahr  NE ls_data-gjahr OR
               <fs_data_191>-belnr  NE ls_data-belnr.
              EXIT.
            ENDIF.
            ADD <fs_data_191>-hsl TO lv_amount_191.
            CLEAR <fs_data_191>-hsl.
          ENDLOOP.
      ENDCASE.

      READ TABLE lt_data_k TRANSPORTING NO FIELDS WITH KEY bukrs = ls_data-bukrs
                                                           gjahr = ls_data-gjahr
                                                           belnr = ls_data-belnr
                                                          BINARY SEARCH.
      CASE sy-subrc.
        WHEN 0.
          LOOP AT lt_data_k ASSIGNING <fs_data> FROM sy-tabix.
            IF <fs_data>-bukrs NE ls_data-bukrs OR
               <fs_data>-gjahr NE ls_data-gjahr OR
               <fs_data>-belnr NE ls_data-belnr.
              EXIT.
            ENDIF.
            ADD <fs_data>-hsl TO lv_amount_k.
            CLEAR <fs_data>-hsl.
          ENDLOOP.
      ENDCASE.
      "ilk tutarlar
***      ls_collect-kst    = ls_data-hsl. "kaldırıldı Çağatay - Sümeyye
*      ls_collect-gyst   = ls_data-hsl +
*                          lv_amount_k -
*                          lv_amount_191.
****      ls_collect-gyst   = lv_amount_k. "kaldırıldı Çağatay -Sümeyye
      READ TABLE lt_data_wh INTO DATA(ls_data_wh) WITH KEY bukrs = ls_data-bukrs
                                                           belnr = ls_data-belnr
                                                           gjahr = ls_data-gjahr
                                                           witht = ls_data-witht BINARY SEARCH.
      ls_collect-gyst = ls_data_wh-baseamount. "Çağatay-Sümeyye
      ls_collect-kst = ls_data_wh-taxamount.

      "kiril1
      ls_collect-kiril1 = ls_mg-kiril1.
      ls_collect-acklm1 = ls_mg-acklm1.
      COLLECT ls_collect INTO mt_collect.

      "kiril2
      ls_collect-kiril2 = ls_mg-kiril2.
      ls_collect-acklm2 = ls_mg-acklm2.
      COLLECT ls_collect INTO mt_collect.

      "kiril3
      CONCATENATE ls_mg-mindk
                  '-'
                  ls_data-racct
                  '/('
                  ls_mg-mtext
                  '-'
                  ls_data-txt50
                  ')'
                  INTO ls_collect-kiril3.

      COLLECT ls_collect INTO mt_collect.

      ls_detail-kiril1 = ls_mg-kiril1.
      ls_detail-acklm1 = ls_mg-acklm1.
      ls_detail-kiril2 = ls_mg-kiril2.
      ls_detail-acklm2 = ls_mg-acklm2.
      ls_detail-belnr  = ls_data-belnr.
      ls_detail-bukrs  = ls_data-bukrs.
      ls_detail-butxt  = ls_data-butxt.
      ls_detail-gjahr  = ls_data-gjahr.
      ls_detail-racct  = ls_data-racct.
      ls_detail-txt50  = ls_data-txt50.
      ls_detail-lifnr  = ls_data-lifnr.
      ls_detail-name1  = ls_data-name1.
      ls_detail-name2  = ls_data-name2.
      ls_detail-mindk  = ls_mg-mindk.
      ls_detail-mtext   = ls_mg-mtext.
      ls_detail-hsl    = ls_data-hsl.
      ls_detail-wsl    = ls_data-wsl.
      ls_detail-rwcur  = ls_data-rwcur.
      ls_detail-sgtxt  = ls_data-sgtxt.
      ls_detail-zuonr  = ls_data-zuonr.
      ls_detail-gyst   = ls_collect-gyst.
      ls_detail-kst    = ls_collect-kst.
      COLLECT ls_detail INTO mt_detail.

      CLEAR ls_mg.
      CLEAR ls_lfb1.
      CLEAR ls_detail.
      CLEAR ls_collect.
      CLEAR ls_data_wh.

      DELETE lt_data_wh WHERE bukrs = ls_data-bukrs
                          AND belnr = ls_data-belnr
                          AND gjahr = ls_data-gjahr
                          AND witht = ls_data-witht.

    ENDLOOP.

    "abs
    LOOP AT mt_collect ASSIGNING <fs_collect>.
      <fs_collect>-gyst = abs( <fs_collect>-gyst ).
      <fs_collect>-kst  = abs( <fs_collect>-kst  ).
    ENDLOOP.


    LOOP AT mt_detail ASSIGNING <fs_detail>.
      <fs_detail>-gyst = abs( <fs_detail>-gyst ).
      <fs_detail>-kst  = abs( <fs_detail>-kst  ).
    ENDLOOP.

    DATA : lv_line TYPE int4.

    LOOP AT mt_collect INTO DATA(ls_col).
      APPEND INITIAL LINE TO et_collect ASSIGNING FIELD-SYMBOL(<fs_col>).
      MOVE-CORRESPONDING ls_col TO <fs_col>.

      lv_line = lv_line + 1.
      <fs_col>-lineitem = lv_line.
    ENDLOOP.

  ENDMETHOD.
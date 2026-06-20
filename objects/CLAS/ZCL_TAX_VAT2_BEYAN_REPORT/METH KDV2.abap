  METHOD kdv2.

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

    IF iv_beyant IS NOT INITIAL.
      p_beyant = iv_beyant.
    ENDIF.

    CALL METHOD fill_monat_range
      EXPORTING
        iv_donemb = p_donemb
      IMPORTING
        er_monat  = mr_monat
        ev_monat  = mv_monat.

    fill_shared_structure( ).

    TYPES BEGIN OF lty_ist.
    TYPES k2type TYPE ztax_t_k2ist-k2type.
    TYPES mwskz  TYPE ztax_t_k2ist-mwskz.
    TYPES END OF lty_ist.

    TYPES BEGIN OF lty_gib.
    TYPES fieldname TYPE ztax_t_gib-fieldname_.
    TYPES alan  TYPE ztax_t_gib-alan.
    TYPES END OF lty_gib.

    DATA ls_kschl_mwskz TYPE mty_kschl_mwskz.
    DATA lt_kschl_mwskz TYPE mtty_kschl_mwskz.
    DATA lt_k1k2  TYPE mtty_kschl_mwskz.
    DATA ls_k1k2  TYPE mty_kschl_mwskz.
    DATA ls_bkpf TYPE mty_bkpf.
    DATA lt_bkpf TYPE SORTED TABLE OF mty_bkpf WITH UNIQUE KEY bukrs belnr gjahr.
    DATA lt_bset TYPE mtty_bset.
    DATA ls_bset TYPE mty_bset.
    DATA ls_bseg TYPE mty_bseg.
    DATA lt_bseg TYPE mtty_bseg.
    DATA ls_map   TYPE mty_map.
    DATA lt_map   TYPE TABLE OF mty_map.
*    DATA ls_collect   TYPE mty_collect.
    DATA ls_collect   TYPE ztax_ddl_i_vat2_beyan_report.
    DATA ls_read_tab  TYPE mty_read_tab.
    DATA lv_fieldname_ita TYPE ztax_t_k2ita-fieldname.
    DATA lt_ist TYPE TABLE OF lty_ist.
    DATA ls_ist TYPE lty_ist.
    DATA lt_gib TYPE TABLE OF lty_gib.
    DATA ls_gib TYPE lty_gib.
    DATA lt_hesap TYPE mtty_hesap.
    DATA ls_hesap TYPE mty_hesap.
    DATA lv_conv_int TYPE i.
    DATA lt_parameters TYPE mtty_hesap.
    DATA lt_k2mt      TYPE TABLE OF ztax_t_k2mt.
    DATA ls_k2mt      TYPE ztax_t_k2mt.
    DATA lv_percent   TYPE i.
    DATA lv_butxt     TYPE c LENGTH 100.
    DATA lv_ita       TYPE ztax_t_k2ita-fieldname.
    DATA lv_kiril2_control TYPE c LENGTH 1.
    DATA lv_outtab_char TYPE c LENGTH 3.
    DATA lv_zta TYPE i.
*    FIELD-SYMBOLS <fs_detail> TYPE ztax_s_detay_001.
    FIELD-SYMBOLS <fs_value>  TYPE any.
    FIELD-SYMBOLS <lt_outtab> TYPE any .
    DATA : dref_it TYPE REF TO data.
    FIELD-SYMBOLS: <t_outtab>    TYPE any.

    " --- YENİ: BSET <-> BSEG-T pozisyonel eşleme için yardımcı yapılar ---
    DATA: BEGIN OF ls_bseg_doc,
            buzei               TYPE c LENGTH 6,
            assignmentreference TYPE i_journalentryitem-assignmentreference,
          END OF ls_bseg_doc.
    DATA lt_bseg_doc LIKE TABLE OF ls_bseg_doc.

    DATA: BEGIN OF ls_bset_pos,
            buzei TYPE i_operationalacctgdoctaxitem-taxitem,
          END OF ls_bset_pos.
    DATA lt_bset_doc LIKE TABLE OF ls_bset_pos.

    DATA lv_pos         TYPE i.
    DATA lv_bset_buzei_c TYPE c LENGTH 6.
    " --- /YENİ ---

    CLEAR me->ms_button_pushed.
    me->ms_button_pushed-kdv2 = abap_true.

    CLEAR mt_collect.
    CLEAR ls_collect.
    CLEAR lt_k1k2.
    CLEAR ls_k1k2.
    CLEAR lt_parameters.
*    CLEAR mt_detail.
*    CLEAR mt_detail_alv.

    lt_map   = mt_map.
    lt_hesap = mt_hesap.
    SORT lt_map BY xmlsr ASCENDING.

    CLEAR ls_read_tab.
    ls_read_tab-bset = abap_true.
    ls_read_tab-bseg = abap_true.

    MOVE-CORRESPONDING mt_bkpf[] TO lt_bkpf[].
    MOVE-CORRESPONDING mt_bset[] TO lt_bset[].
    MOVE-CORRESPONDING mt_bseg[] TO lt_bseg[].

    CLEAR lv_ita.
    SELECT SINGLE fieldname
            FROM ztax_t_k2ita
            INTO @lv_ita.

    SELECT k2type,
           mwskz
           FROM ztax_t_k2ist
           INTO TABLE @lt_ist.


    SELECT fieldname_, alan
           FROM ztax_t_gib
       WHERE bukrs  EQ @p_bukrs
         AND beyant EQ @p_beyant
         INTO TABLE @lt_gib.

    SORT lt_ist BY k2type mwskz.

    CLEAR lv_butxt.
    SELECT SINGLE companycodename AS butxt
           FROM i_companycode
           WHERE companycode EQ @p_bukrs
           INTO @lv_butxt.

    SORT lt_bseg BY bukrs belnr gjahr buzid mwskz.

    lt_parameters = lt_hesap.
    SORT lt_parameters BY hesaptip ASCENDING kschl.
    DELETE ADJACENT DUPLICATES FROM lt_parameters COMPARING hesaptip kschl.

    me->filter_kschl_from_formul( CHANGING ct_hesap = lt_hesap ).

    SORT lt_hesap BY hesaptip ASCENDING kschl.
    DELETE ADJACENT DUPLICATES FROM lt_hesap COMPARING hesaptip kschl.

    CLEAR lt_parameters.
    lt_parameters = lt_hesap.
    SORT lt_parameters BY kschl.
    DELETE ADJACENT DUPLICATES FROM lt_parameters COMPARING kschl.


    LOOP AT lt_map INTO ls_map.
      READ TABLE lt_ist INTO ls_ist WITH KEY k2type = ls_map-kiril2
                                             mwskz  = ls_map-mwskz
                                             BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        LOOP AT lt_bset INTO ls_bset WHERE mwskz EQ ls_map-mwskz.
          CLEAR ls_kschl_mwskz.

          CLEAR ls_bkpf.
          READ TABLE lt_bkpf INTO ls_bkpf WITH TABLE KEY bukrs = ls_bset-bukrs
                                                         belnr = ls_bset-belnr
                                                         gjahr = ls_bset-gjahr.

          CLEAR ls_bseg.
          READ TABLE lt_bseg INTO ls_bseg WITH KEY bukrs = ls_bset-bukrs
                                                   belnr = ls_bset-belnr
                                                   gjahr = ls_bset-gjahr
                                                   buzid = 'T'
                                                   mwskz = ls_map-mwskz
                                                   BINARY SEARCH.
          " sy-tabix / sy-subrc lt_bseg READ'inden HEMEN kaydediliyor;
          " aşağıdaki lt_parameters READ bunların üzerine yazar.
          DATA(lv_bseg_tabix) = sy-tabix.
          DATA(lv_bseg_subrc) = sy-subrc.


          READ TABLE lt_parameters TRANSPORTING NO FIELDS
                WITH KEY kschl = ls_bset-kschl BINARY SEARCH.
          CHECK sy-subrc  IS INITIAL.
          ls_kschl_mwskz-kiril1 = ls_map-kiril1.
          ls_kschl_mwskz-acklm1 = ls_map-acklm1.
          ls_kschl_mwskz-kiril2 = ls_map-kiril2.
          ls_kschl_mwskz-acklm2 = ls_map-acklm2.
          ls_kschl_mwskz-mwskz  = ls_bset-mwskz.
          ls_kschl_mwskz-shkzg  = ls_bset-shkzg.
          ls_kschl_mwskz-kbetr  = ls_bset-kbetr.
          ls_kschl_mwskz-hwbas  = ls_bset-hwbas.
          ls_kschl_mwskz-kschl  = ls_bset-kschl.
          ls_kschl_mwskz-hwste  = ls_bset-hwste.
          ls_kschl_mwskz-xmlsr  = ls_map-xmlsr.

          IF lv_ita IS NOT INITIAL.
            " --- YENİ MANTIK: 1:1 pozisyonel eşleştirme ---
            " Aynı belge (bukrs/belnr/gjahr) + aynı mwskz grubu içindeki
            " BSET satırlarını buzei'ye göre sıralı bir liste yapıyoruz,
            " aynı şekilde BSEG-T satırlarını da buzei'ye göre sıralı
            " bir liste yapıyoruz. ls_bset şu an kaçıncı sıradaysa,
            " BSEG-T listesindeki AYNI sıradaki satırın
            " AssignmentReference'ına bakıyoruz. Böylece aynı belgede
            " birden fazla kiril2 (örn. 207/212/213 ya da 214/227)
            " bulunsa bile her BSET satırı SADECE KENDİ karşılığı olan
            " kiril2'ye yazılır; çapraz-bucket duplikasyon oluşmaz.

            DATA(lv_ita_found) = abap_false.

            IF lv_bseg_subrc IS INITIAL.

              " --- bu belge + bu mwskz için BSET satırlarını topla ---
              CLEAR lt_bset_doc.
              LOOP AT lt_bset INTO DATA(ls_bset_doc) WHERE bukrs = ls_bset-bukrs
                                                       AND belnr = ls_bset-belnr
                                                       AND gjahr = ls_bset-gjahr
                                                       AND mwskz = ls_map-mwskz.
                CLEAR ls_bset_pos.
                ls_bset_pos-buzei = ls_bset_doc-buzei.
                APPEND ls_bset_pos TO lt_bset_doc.
              ENDLOOP.
              SORT lt_bset_doc BY buzei.

              " --- bu belge + bu mwskz için BSEG-T satırlarını topla ---
              CLEAR lt_bseg_doc.
              LOOP AT lt_bseg INTO ls_bseg FROM lv_bseg_tabix.
                " Belge anahtarı veya vergi kodu değişti: aramayı durdur
                IF ls_bseg-bukrs NE ls_bset-bukrs OR
                   ls_bseg-belnr NE ls_bset-belnr OR
                   ls_bseg-gjahr NE ls_bset-gjahr OR
                   ls_bseg-buzid NE 'T'            OR
                   ls_bseg-mwskz NE ls_map-mwskz.
                  EXIT.
                ENDIF.
                CLEAR ls_bseg_doc.
                ls_bseg_doc-buzei               = ls_bseg-buzei.
                ls_bseg_doc-assignmentreference = ls_bseg-assignmentreference.
                APPEND ls_bseg_doc TO lt_bseg_doc.
              ENDLOOP.
              SORT lt_bseg_doc BY buzei.

              " --- ls_bset'in lt_bset_doc içindeki pozisyonunu bul ---
              CLEAR lv_pos.
              lv_bset_buzei_c = ls_bset-buzei.
              LOOP AT lt_bset_doc INTO ls_bset_pos.
                IF ls_bset_pos-buzei = ls_bset-buzei.
                  lv_pos = sy-tabix.
                  EXIT.
                ENDIF.
              ENDLOOP.

              " --- aynı pozisyondaki BSEG-T satırının AssignmentReference'ı kiril2'ye eşit mi? ---
              IF lv_pos > 0 AND lv_pos <= lines( lt_bseg_doc ).
                READ TABLE lt_bseg_doc INTO ls_bseg_doc INDEX lv_pos.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT lv_ita OF STRUCTURE ls_bseg_doc TO <fs_value>.
                  IF <fs_value> IS ASSIGNED AND <fs_value> EQ ls_map-kiril2.
                    lv_ita_found = abap_true.
                  ENDIF.
                  UNASSIGN <fs_value>.
                ENDIF.
              ENDIF.

              " --- Fallback: sadece TEK bir BSEG-T satırı varsa (tek kalemli belge,
              "     örn. 224 senaryosu), pozisyon hesaplamasına gerek yok ---
              IF lv_ita_found = abap_false AND lines( lt_bseg_doc ) = 1.
                READ TABLE lt_bseg_doc INTO ls_bseg_doc INDEX 1.
                ASSIGN COMPONENT lv_ita OF STRUCTURE ls_bseg_doc TO <fs_value>.
                IF <fs_value> IS ASSIGNED AND <fs_value> EQ ls_map-kiril2.
                  lv_ita_found = abap_true.
                ENDIF.
                UNASSIGN <fs_value>.
              ENDIF.

            ENDIF.

            IF lv_ita_found = abap_true.
              COLLECT ls_kschl_mwskz INTO lt_kschl_mwskz.
              CLEAR ls_kschl_mwskz.
            ENDIF.
            UNASSIGN <fs_value>.
            " --- /YENİ MANTIK ---

          ELSEIF lines( lt_gib ) GT 0.

            LOOP AT lt_gib INTO ls_gib.

              CREATE DATA : dref_it TYPE (ls_gib-fieldname).
              ASSIGN dref_it->* TO <lt_outtab>.
              ASSIGN COMPONENT ls_gib-alan OF STRUCTURE <lt_outtab> TO <t_outtab>.

              CASE ls_bkpf-awtyp(1).
                WHEN 'R'.
                  SELECT SINGLE originalreferencedocument AS awkey FROM i_journalentry
                     WHERE companycode = @ls_bkpf-bukrs
                       AND accountingdocument = @ls_bkpf-belnr
                       AND fiscalyear = @ls_bkpf-gjahr
                       INTO @DATA(lv_awkey).

                  IF sy-subrc EQ 0.
                    SELECT SINGLE (ls_gib-alan) FROM (ls_gib-fieldname)
                    WHERE bukrs = @ls_bkpf-bukrs
                      AND belnr = @lv_awkey(10)
                      AND gjahr = @ls_bkpf-gjahr
                      INTO @<t_outtab>.
                  ENDIF.

                WHEN 'B'.
                  SELECT SINGLE (ls_gib-alan) FROM (ls_gib-fieldname)
                     WHERE bukrs = @ls_bkpf-bukrs
                       AND belnr = @ls_bkpf-belnr
                       AND gjahr = @ls_bkpf-gjahr
                        INTO @<t_outtab>.

                WHEN 'I'.
                  SELECT SINGLE (ls_gib-alan) FROM (ls_gib-fieldname)
                   WHERE bukrs = @ls_bkpf-bukrs
                     AND invno = @ls_bkpf-xblnr
                     AND gjahr = @ls_bkpf-gjahr
                     INTO @<t_outtab>.
              ENDCASE.
              IF <t_outtab> IS INITIAL.
                SELECT SINGLE (ls_gib-alan) FROM (ls_gib-fieldname)
                                            WHERE bukrs = @ls_bkpf-bukrs
                                              AND belnr = @ls_bkpf-belnr
                                              AND gjahr = @ls_bkpf-gjahr
                                               INTO @<t_outtab>.

              ENDIF.
*              MOVE <t_outtab> TO lv_outtab_char. "değiştirildi
              lv_outtab_char = CONV string( <t_outtab> ).
              IF lv_outtab_char(1) EQ '6'.
                lv_outtab_char(1) = '2'.
              ENDIF.
              CLEAR lv_kiril2_control.
              IF lv_outtab_char EQ ls_map-kiril2.
                lv_kiril2_control = abap_true.
                COLLECT ls_kschl_mwskz INTO lt_kschl_mwskz.
                CLEAR ls_kschl_mwskz.
                EXIT.
              ENDIF.
            ENDLOOP.
          ELSEIF lines( lt_ist ) GT 0.
            CLEAR ls_ist.
            READ TABLE lt_ist INTO ls_ist WITH KEY mwskz  = ls_map-mwskz.
            IF sy-subrc EQ 0.
              COLLECT ls_kschl_mwskz INTO lt_kschl_mwskz.
              CLEAR ls_kschl_mwskz.
            ENDIF.
          ENDIF.

        ENDLOOP.
        IF sy-subrc IS NOT INITIAL.
          CLEAR ls_collect.
          ls_collect-kiril1 = ls_k1k2-kiril1.
          ls_collect-acklm1 = ls_k1k2-acklm1.
          COLLECT ls_collect INTO mt_collect.
          ls_collect-kiril2 = ls_k1k2-kiril2.
          ls_collect-acklm2 = ls_k1k2-acklm2.
          COLLECT ls_collect INTO mt_collect.
          ls_collect-kiril3 = ls_map-mwskz.
          COLLECT ls_collect INTO mt_collect.
          CLEAR ls_collect.
        ENDIF.
      ENDIF.
    ENDLOOP.

    SELECT *
    FROM ztax_t_k2mt
    WHERE bukrs EQ @p_bukrs
      AND gjahr EQ @p_gjahr
      AND monat IN @mr_monat
      AND mwskz IN @mr_mwskz
    INTO TABLE @lt_k2mt.

    lt_k1k2 = lt_kschl_mwskz.
    SORT lt_k1k2 BY kiril1 kiril2 mwskz.
    DELETE ADJACENT DUPLICATES FROM lt_k1k2 COMPARING kiril1 kiril2 mwskz.


    LOOP AT lt_k1k2 INTO ls_k1k2.
      CLEAR ls_collect.
      me->set_parameter_value( EXPORTING iv_kiril1      = ls_k1k2-kiril1
                                         iv_kiril2      = ls_k1k2-kiril2
                                         iv_mwskz       = ls_k1k2-mwskz
                                         it_kschl_mwskz = lt_kschl_mwskz
                               CHANGING  ct_parameters  = lt_parameters ).


      me->fill_amount_fields( EXPORTING it_hesap      = lt_hesap
                                        it_parameters = lt_parameters
                              CHANGING  cs_collect    = ls_collect ).

      ls_collect-kiril1 = ls_k1k2-kiril1.
      ls_collect-acklm1 = ls_k1k2-acklm1.

      ls_collect-kiril2 = ls_k1k2-kiril2.
      ls_collect-acklm2 = ls_k1k2-acklm2.
      ls_collect-kiril3 = ls_k1k2-mwskz.
*kaldırıldı Çağatay-Sümeyye
*      CLEAR lv_conv_int.
*      lv_conv_int = ls_collect-tevkifato.
*      CLEAR ls_collect-tevkifato.
*      ls_collect-tevkifato = lv_conv_int.
*
*      SHIFT ls_collect-tevkifato LEFT DELETING LEADING space.
*      CONCATENATE ls_collect-tevkifato
*                  '/10'
*                  INTO ls_collect-tevkifato .
*      CLEAR lv_conv_int.
*      lv_conv_int = ls_collect-oran.
*      CLEAR ls_collect-oran.
*      ls_collect-oran = lv_conv_int.
************Kaldırıldı -son Çağatay - Sümeyye
*eklendi Çağatay - Sümeyye
      " Hesaplama Tipi 2: oran = MWVS + NLXV  (tüm non-ZTRA kbetr'ler toplanır)
      " Hesaplama Tipi 3: tevkifato = (ZTRA / (MWVS+NLXV)) * 10
*      CLEAR:  lv_conv_int ,lv_zta.
*      LOOP AT lt_kschl_mwskz INTO DATA(ls_kschl_mwskz2) WHERE kiril1 = ls_k1k2-kiril1
*                                                          AND kiril2 = ls_k1k2-kiril2.
*        IF ls_kschl_mwskz2-kschl = 'ZTRA'.
*          lv_zta = abs( ls_kschl_mwskz2-kbetr ).           " ZTRA oranı
*        ELSE.
*          lv_conv_int = lv_conv_int + abs( ls_kschl_mwskz2-kbetr ). " MWVS + NLXV toplamı
*        ENDIF.
*      ENDLOOP.
*      " (ZTRA / (MWVS+NLXV)) * 10
*      IF lv_conv_int > 0.
*        lv_zta = ( lv_zta / lv_conv_int ) * 10.
*      ELSE.
*        CLEAR lv_zta.
*      ENDIF.
*      ls_collect-tevkifato = |{ lv_zta }/10|.
*      ls_collect-oran = lv_conv_int.
**eklendi-son


"test
      " Döngü içinde kullanılacak ondalıklı yeni değişken tanımlamaları
      DATA: lv_conv_dec TYPE p LENGTH 16 DECIMALS 3,
            lv_zta_dec  TYPE p LENGTH 16 DECIMALS 3,
            lv_oran_num TYPE p LENGTH 16 DECIMALS 3.

      CLEAR: lv_conv_dec, lv_zta_dec, lv_oran_num.

      LOOP AT lt_kschl_mwskz INTO DATA(ls_kschl_mwskz2)
           WHERE kiril1 = ls_k1k2-kiril1
             AND kiril2 = ls_k1k2-kiril2
             AND mwskz  = ls_k1k2-mwskz. " Eksik olan kritik filtre eklendi

        DATA(lv_kbetr_num) = CONV decfloat34( ls_kschl_mwskz2-kbetr ).

        IF ls_kschl_mwskz2-kschl = 'ZTRA'.
          lv_zta_dec = abs( lv_kbetr_num ).
        ELSE.
          lv_conv_dec = lv_conv_dec + abs( lv_kbetr_num ).
        ENDIF.
      ENDLOOP.

      IF lv_conv_dec > 0.
        lv_oran_num = ( lv_zta_dec / lv_conv_dec ) * 10.
      ELSE.
        CLEAR lv_oran_num.
      ENDIF.

      ls_collect-tevkifato = |{ lv_oran_num DECIMALS = 0 }/10|.
      ls_collect-oran      = |{ lv_conv_dec DECIMALS = 0 }|.

"test

      COLLECT ls_collect INTO mt_collect.

      CLEAR ls_collect-kiril3.
      CLEAR ls_collect-oran.
      CLEAR ls_collect-tevkifato.
      COLLECT ls_collect INTO mt_collect.

      CLEAR ls_collect-kiril2.
      CLEAR ls_collect-acklm2.
      COLLECT ls_collect INTO mt_collect.
      CLEAR ls_collect.

    ENDLOOP.


    SORT lt_map BY kiril2.

    LOOP AT lt_k2mt INTO ls_k2mt.

      CLEAR ls_map.
      CLEAR lv_percent.
      CLEAR ls_collect.

      READ TABLE lt_map INTO ls_map WITH KEY kiril2 = ls_k2mt-k2type BINARY SEARCH.

      ls_collect-kiril1   = ls_map-kiril1.
      ls_collect-acklm1   = ls_map-acklm1.
      ls_collect-matrah   = ls_k2mt-matrah.
      ls_collect-tevkifat = ls_k2mt-tevkt.
      ls_collect-vergi    = ls_k2mt-vergi.
      COLLECT ls_collect INTO mt_collect.

      ls_collect-kiril2 = ls_map-kiril2.
      ls_collect-acklm2 = ls_map-acklm2.

      COLLECT ls_collect INTO mt_collect.
      TRY.
          lv_percent = ( ls_k2mt-tevkt / ls_k2mt-vergi ) * 10.
        CATCH cx_root.
          CLEAR lv_percent.
      ENDTRY.

      ls_collect-tevkifato = lv_percent.
      SHIFT ls_collect-tevkifato LEFT DELETING LEADING space.
      CONCATENATE ls_collect-tevkifato
                  '/10'
                  INTO ls_collect-tevkifato.
      ls_collect-kiril3 = ls_k2mt-mwskz.

      CLEAR lv_percent.
      TRY.
          lv_percent = ( ls_k2mt-vergi / ls_k2mt-matrah ) * 100.
        CATCH cx_root.
          CLEAR lv_percent.
      ENDTRY.
      ls_collect-oran = lv_percent.
      COLLECT ls_collect INTO mt_collect.
      CLEAR ls_collect.

    ENDLOOP.

    et_collect = mt_collect.
    er_monat   = mr_monat.

  ENDMETHOD.
  METHOD kdv1.

    DATA ls_bkpf  TYPE mty_bkpf.
    DATA lt_bkpf  TYPE TABLE OF mty_bkpf.
    DATA lt_bset  TYPE mtty_bset.
    DATA ls_bset  TYPE mty_bset.
    DATA lv_tabix TYPE sy-tabix.

    DATA lv_kbetr_s TYPE p LENGTH 16 DECIMALS 2.
    DATA lv_kbetr_h TYPE p LENGTH 16 DECIMALS 2.
    DATA lv_oran    TYPE p LENGTH 16 DECIMALS 2.
    DATA lv_bypass  TYPE abap_boolean.

    DATA ls_map   TYPE mty_map.
    DATA ls_map2  TYPE mty_map.
    DATA lt_map   TYPE TABLE OF mty_map.
    DATA lv_oran_int TYPE i.
    DATA lv_kiril3 TYPE ztax_e_acklm.

    DATA ls_collect TYPE ztax_ddl_i_vat1_dec_report.
    DATA lt_tax_voran TYPE TABLE OF ztax_t_voran.
    DATA ls_tax_voran TYPE ztax_t_voran.

    TYPES BEGIN OF lty_k1mt.
    TYPES bukrs    TYPE ztax_t_k1mt-bukrs.
    TYPES gjahr    TYPE ztax_t_k1mt-gjahr.
    TYPES monat    TYPE ztax_t_k1mt-monat.
    TYPES kiril1   TYPE ztax_t_k1mt-kiril1.
    TYPES kiril2   TYPE ztax_t_k1mt-kiril2.
    TYPES mwskz    TYPE ztax_t_k1mt-mwskz.
    TYPES kschl    TYPE ztax_t_k1mt-kschl.
    TYPES hkont    TYPE ztax_t_k1mt-hkont.
    TYPES matrah   TYPE ztax_t_k1mt-matrah.
    TYPES vergi    TYPE ztax_t_k1mt-vergi.
    TYPES tevkt    TYPE ztax_t_k1mt-tevkt.
    TYPES manuel   TYPE ztax_t_k1mt-manuel.
    TYPES vergidis TYPE ztax_t_k1mt-vergidis.
    TYPES vergiic  TYPE ztax_t_k1mt-vergiic.
    TYPES END OF lty_k1mt.

    TYPES BEGIN OF lty_topal.
    TYPES split TYPE c LENGTH 10.
    TYPES END OF lty_topal.

    DATA ls_k1mt   TYPE lty_k1mt.
    DATA lt_k1mt   TYPE TABLE OF lty_k1mt.
    DATA ls_topal  TYPE lty_topal.
    DATA lt_topal  TYPE TABLE OF lty_topal.
    DATA lv_kiril2 TYPE ztax_e_kiril2.
    DATA lv_kiril1 TYPE ztax_e_kiril1.

    DATA ls_kostr TYPE mty_kostr.
    DATA lt_kostr TYPE TABLE OF mty_kostr.

    TYPES BEGIN OF lty_kostr_field.
    TYPES split TYPE c LENGTH 10.
    TYPES END OF lty_kostr_field.

    DATA lt_kostr_field TYPE TABLE OF lty_kostr_field.

    DATA lv_index       TYPE i.
    DATA lv_found_index TYPE i.
    DATA lv_length      TYPE i.

    DATA lv_butxt TYPE i_companycode-companycodename.

    TYPES BEGIN OF lty_kschl.
    TYPES sign(1) TYPE c.
    TYPES kschl TYPE kschl.
    TYPES END OF lty_kschl.

    DATA ls_kschl TYPE lty_kschl.
    DATA lt_kschl TYPE TABLE OF lty_kschl.
    DATA lr_kschl TYPE RANGE OF kschl.
    DATA lv_thlog_wrbtr TYPE ztax_t_thlog-wrbtr.

    DATA ls_read_tab TYPE mty_read_tab.
    DATA lt_bseg TYPE TABLE OF mty_bseg.
    DATA ls_bseg TYPE mty_bseg.
    DATA lr_saknr TYPE RANGE OF i_operationalacctgdocitem-operationalglaccount.
    FIELD-SYMBOLS <fs_range>   TYPE any.
    FIELD-SYMBOLS <fs_field>   TYPE any.
    FIELD-SYMBOLS <fs_collect> TYPE ztax_ddl_i_vat1_dec_report.
    FIELD-SYMBOLS <lt_outtab> TYPE any.

    DATA : dref_it TYPE REF TO data.
    FIELD-SYMBOLS: <t_outtab> TYPE any.

    DATA lr_ktosl TYPE RANGE OF ktosl.

    " lv_ita mantığı için yeni alanlar
    DATA lv_ita TYPE ztax_t_k2ita-fieldname.
    FIELD-SYMBOLS <fs_value> TYPE any.

    DATA: BEGIN OF ls_bseg_doc,
            buzei               TYPE c LENGTH 6,
            assignmentreference TYPE i_journalentryitem-assignmentreference,
          END OF ls_bseg_doc.
    DATA lt_bseg_doc LIKE TABLE OF ls_bseg_doc.

    DATA: BEGIN OF ls_bset_pos,
            buzei TYPE buzei,
          END OF ls_bset_pos.
    DATA lt_bset_doc LIKE TABLE OF ls_bset_pos.

    DATA lv_pos TYPE i.
    DATA lv_bseg_tabix TYPE sy-tabix.
    DATA lv_bseg_subrc TYPE sysubrc.
    DATA lv_ita_found TYPE abap_boolean.

    CLEAR me->ms_button_pushed.
    me->ms_button_pushed-kdv1 = abap_true.

    IF iv_bukrs IS NOT INITIAL.
      p_bukrs = iv_bukrs.
    ENDIF.
    IF iv_gjahr IS NOT INITIAL.
      p_gjahr = iv_gjahr.
    ENDIF.
    IF iv_monat IS NOT INITIAL.
      p_monat = iv_monat.
    ENDIF.
    IF iv_beyant IS NOT INITIAL.
      p_beyant = iv_beyant.
    ENDIF.
    IF iv_donemb IS NOT INITIAL.
      p_donemb = iv_donemb.
    ENDIF.

    fill_monat_range( ).
    fill_det_kural_range( ).

    CLEAR mt_collect.

    me->get_condition_type( IMPORTING et_kostr = lt_kostr ).
    me->get_map_tab( IMPORTING et_map = lt_map ).

    SORT lt_map BY xmlsr ASCENDING.

    me->fill_saknr_range( EXPORTING it_map   = lt_map
                          IMPORTING er_saknr = lr_saknr ).
    me->get_prev_balance( IMPORTING ev_balance = lv_thlog_wrbtr ).

    CLEAR ls_read_tab.
    ls_read_tab-bset = abap_true.
    ls_read_tab-bseg = abap_true.
    me->find_document( EXPORTING is_read_tab = ls_read_tab
                                 ir_saknr    = lr_saknr
                       IMPORTING et_bkpf     = lt_bkpf
                                 et_bset     = lt_bset
                                 et_bseg     = lt_bseg ).

    " lv_ita alanı
    SELECT SINGLE fieldname
      FROM ztax_t_k2ita
      INTO @lv_ita.

    SELECT bukrs,
           gjahr,
           monat,
           kiril1,
           kiril2,
           mwskz,
           kschl,
           hkont,
           matrah,
           vergi,
           tevkt,
           manuel,
           vergidis,
           vergiic
      FROM ztax_t_k1mt
      WHERE bukrs EQ @p_bukrs
        AND gjahr EQ @p_gjahr
        AND monat IN @mr_monat
      INTO TABLE @lt_k1mt.

    SELECT SINGLE companycodename AS butxt
      FROM i_companycode
      WHERE companycode EQ @p_bukrs
      INTO @lv_butxt.

    SELECT
      j~accountingdocumenttype AS blart,
      j~glaccount AS hkont,
      j~amountincompanycodecurrency  AS tutar
      FROM i_journalentryitem AS j
      INNER JOIN @lt_map AS map
        ON map~saknr = j~glaccount
       AND map~blart = j~accountingdocumenttype
      WHERE j~ledger = '0L'
        AND j~companycode = @p_bukrs
        AND j~fiscalyear = @p_gjahr
        AND j~fiscalperiod = @p_monat
        AND j~isreversal = ''
        AND j~isreversed = ''
        AND ( j~debitcreditcode = 'S' )
        AND map~kiril1 = '30'
      INTO TABLE @DATA(lt_creditcart).

    SELECT
      j~accountingdocumenttype AS blart,
      j~glaccount AS hkont,
      j~amountincompanycodecurrency  AS tutar
      FROM i_journalentryitem AS j
      INNER JOIN @lt_map AS map
        ON map~saknr = j~glaccount
       AND map~blart = j~accountingdocumenttype
      WHERE j~ledger = '0L'
        AND j~companycode = @p_bukrs
        AND j~fiscalyear = @p_gjahr
        AND j~fiscalperiod = @p_monat
        AND j~isreversal = ''
        AND ( j~isreversed = 'X' OR j~isreversed = 'X' )
        AND ( j~debitcreditcode = 'H' )
        AND map~kiril1 = '30'
      INTO TABLE @DATA(lt_creditcart_rev).

    SELECT
      j~glaccount AS hkont,
      SUM( j~amountincompanycodecurrency ) AS hwste
      FROM i_journalentryitem AS j
      INNER JOIN @lt_map AS map
        ON map~saknr  = j~glaccount
       AND map~kural = '004'
      WHERE j~ledger      = '0L'
        AND j~companycode = @p_bukrs
        AND j~isreversal  = ''
        AND j~isreversed  = ''
        AND ( j~fiscalyear < @p_gjahr
           OR ( j~fiscalyear  = @p_gjahr
            AND j~fiscalperiod < @p_monat ) )
      GROUP BY j~glaccount
      INTO TABLE @DATA(lt_indirim).

    SELECT
      j~glaccount AS hkont,
      j~taxcode AS mwskz,
      r~conditionrateratio AS kbetr,
      SUM( CASE WHEN ( j~transactiontypedetermination = 'VST' OR
                       j~transactiontypedetermination = 'MWS' OR
                       j~transactiontypedetermination = ' ' ) THEN j~amountincompanycodecurrency ELSE 0 END ) AS hwste,
      SUM( CASE WHEN ( j~transactiontypedetermination <> 'VST' AND
                       j~transactiontypedetermination <> 'MWS' AND
                       j~transactiontypedetermination <> 'ZTA' ) THEN j~amountincompanycodecurrency ELSE 0 END ) AS hwbas
      FROM i_journalentryitem AS j
      INNER JOIN @lt_map AS map
        ON map~saknr = j~glaccount
       AND map~mwskz = j~taxcode
       AND map~kiril1 = '99'
      LEFT OUTER JOIN i_taxcoderate AS r
        ON r~cndnrecordvaliditystartdate <= j~documentdate
       AND r~cndnrecordvalidityenddate >= j~documentdate
       AND r~taxcode = j~taxcode
      WHERE j~ledger = '0L'
        AND j~companycode = @p_bukrs
        AND j~fiscalyear = @p_gjahr
        AND j~fiscalperiod = @p_monat
        AND j~isreversal = ''
        AND j~isreversed = ''
      GROUP BY j~glaccount, j~taxcode, r~conditionrateratio
      INTO TABLE @DATA(lt_ozel).

    IF sy-subrc = 0.
      LOOP AT lt_ozel ASSIGNING FIELD-SYMBOL(<ls_ozel>).
        <ls_ozel>-hwste = <ls_ozel>-hwbas * ( <ls_ozel>-kbetr / 100 ).
      ENDLOOP.
    ENDIF.

    SELECT
      j~taxcode AS mwskz,
      r~conditionrateratio AS kbetr,
      r~vatconditiontype AS kschl,
      SUM( j~amountincompanycodecurrency ) AS hwste
      FROM i_journalentryitem AS j
      LEFT OUTER JOIN i_taxcoderate AS r
        ON  r~cndnrecordvaliditystartdate <= j~documentdate
        AND r~cndnrecordvalidityenddate   >= j~documentdate
        AND r~taxcode                      = j~taxcode
        AND ( r~accountkeyforglaccount = 'VST'
           OR r~accountkeyforglaccount = 'MWS' )
      WHERE j~ledger               = '0L'
        AND j~companycode          = @p_bukrs
        AND j~fiscalyear           = @p_gjahr
        AND j~fiscalperiod         = @p_monat
        AND j~isreversal           = ''
        AND j~isreversed           = ''
        AND ( j~financialaccounttype = 'S'
           OR j~financialaccounttype = 'A' )
        AND j~taxcode              <> ''
        AND j~transactiontypedetermination = 'ZTA'
        AND j~debitcreditcode      = 'H'
      GROUP BY j~taxcode, r~conditionrateratio, r~vatconditiontype
      ORDER BY j~taxcode
      INTO TABLE @DATA(lt_109).

    SORT lt_map BY xmlsr ASCENDING kural ASCENDING.
    SORT lt_bseg BY bukrs belnr gjahr buzid mwskz buzei.
    SORT lt_bset BY bukrs belnr gjahr mwskz buzei.

    LOOP AT lt_map INTO ls_map WHERE topal EQ space.
      CASE ls_map-kural.

        WHEN '001' OR '003' OR '005'.
          CLEAR lv_tabix.

          lr_ktosl = VALUE #( sign = 'I' option = 'EQ' ( low = 'MWS' )
                                                       ( low = 'VST' ) ).

          IF ls_map-saknr IS NOT INITIAL.

            LOOP AT lt_bset INTO ls_bset WHERE mwskz EQ ls_map-mwskz.

              IF ls_bset-hkont(3) = '198' OR ls_bset-hkont EQ '6430000001'.
                CONTINUE.
              ENDIF.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-kiril2 = ls_map-kiril2.
              ls_collect-acklm2 = ls_map-acklm2.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              ls_collect-islem_tur = ls_map-islem_tur.
              ls_collect-odeme_tur = ls_map-odeme_tur.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-kiril2 = ls_map-kiril2.
              ls_collect-acklm2 = ls_map-acklm2.
              ls_collect-kiril3 = ls_map-mwskz.
              CLEAR lv_oran_int.
              lv_oran_int = abs( ls_bset-kbetr ).
              ls_collect-oran = lv_oran_int.
              SHIFT ls_collect-oran LEFT DELETING LEADING space.
              ls_collect-islem_tur = ls_map-islem_tur.
              ls_collect-odeme_tur = ls_map-odeme_tur.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.
            ENDLOOP.

            IF sy-subrc IS NOT INITIAL.
              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              COLLECT ls_collect INTO mt_collect.
              ls_collect-kiril2 = ls_map-kiril2.
              ls_collect-acklm2 = ls_map-acklm2.
              COLLECT ls_collect INTO mt_collect.
              ls_collect-kiril3 = ls_map-mwskz.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.
            ENDIF.

          ELSE.

            IF ls_map-kiril1 = '109'.

              LOOP AT lt_109 INTO DATA(ls_109) WHERE mwskz = ls_map-mwskz.
                CLEAR ls_collect.
                ls_collect-kiril1 = ls_map-kiril1.
                ls_collect-acklm1 = ls_map-acklm1.
                ls_collect-vergi  = ls_109-hwste.
                ls_collect-islem_tur = ls_map-islem_tur.
                ls_collect-odeme_tur = ls_map-odeme_tur.
                COLLECT ls_collect INTO mt_collect.
                CLEAR ls_collect.

                CLEAR ls_collect.
                ls_collect-kiril1 = ls_map-kiril1.
                ls_collect-acklm1 = ls_map-acklm1.
                ls_collect-kiril2 = ls_map-kiril2.
                ls_collect-acklm2 = ls_map-acklm2.
                ls_collect-islem_tur = ls_map-islem_tur.
                ls_collect-odeme_tur = ls_map-odeme_tur.
                ls_collect-vergi  = ls_109-hwste.
                COLLECT ls_collect INTO mt_collect.
                CLEAR ls_collect.

                CLEAR ls_collect.
                ls_collect-kiril1 = ls_map-kiril1.
                ls_collect-acklm1 = ls_map-acklm1.
                ls_collect-kiril2 = ls_map-kiril2.
                ls_collect-acklm2 = ls_map-acklm2.
                ls_collect-kiril3 = ls_map-mwskz.
                CLEAR lv_oran_int.
                lv_oran_int = abs( ls_109-kbetr ).
                ls_collect-oran = lv_oran_int.
                SHIFT ls_collect-oran LEFT DELETING LEADING space.
                ls_collect-vergi  = ls_109-hwste.
                ls_collect-islem_tur = ls_map-islem_tur.
                ls_collect-odeme_tur = ls_map-odeme_tur.
                COLLECT ls_collect INTO mt_collect.
                CLEAR ls_collect.
              ENDLOOP.

            ELSE.

              LOOP AT lt_bset INTO ls_bset WHERE mwskz EQ ls_map-mwskz.

                IF ls_bset-hkont(3) = '198' OR ls_bset-hkont EQ '6430000001'.
                  CONTINUE.
                ENDIF.

                IF ls_bset-hkont(3) = '391' AND ls_bset-hwbas <> 0.
                  ls_bset-hwste = ls_bset-hwbas.
                  CLEAR ls_bset-hwbas.
                ENDIF.

                " lv_ita mantığı
                lv_ita_found = abap_false.

                IF lv_ita IS NOT INITIAL.

                  READ TABLE lt_bseg INTO ls_bseg WITH KEY bukrs = ls_bset-bukrs
                                                           belnr = ls_bset-belnr
                                                           gjahr = ls_bset-gjahr
                                                           buzid = 'T'
                                                           mwskz = ls_map-mwskz
                                                           BINARY SEARCH.
                  lv_bseg_tabix = sy-tabix.
                  lv_bseg_subrc = sy-subrc.

                  IF lv_bseg_subrc IS INITIAL.

                    CLEAR lt_bset_doc.
                    LOOP AT lt_bset INTO DATA(ls_bset_doc2)
                         WHERE bukrs = ls_bset-bukrs
                           AND belnr = ls_bset-belnr
                           AND gjahr = ls_bset-gjahr
                           AND mwskz = ls_map-mwskz.
                      CLEAR ls_bset_pos.
                      ls_bset_pos-buzei = ls_bset_doc2-buzei.
                      APPEND ls_bset_pos TO lt_bset_doc.
                    ENDLOOP.
                    SORT lt_bset_doc BY buzei.

                    CLEAR lt_bseg_doc.
                    LOOP AT lt_bseg INTO ls_bseg FROM lv_bseg_tabix.
                      IF ls_bseg-bukrs NE ls_bset-bukrs OR
                         ls_bseg-belnr NE ls_bset-belnr OR
                         ls_bseg-gjahr NE ls_bset-gjahr OR
                         ls_bseg-buzid NE 'T' OR
                         ls_bseg-mwskz NE ls_map-mwskz.
                        EXIT.
                      ENDIF.

                      CLEAR ls_bseg_doc.
                      ls_bseg_doc-buzei               = ls_bseg-buzei.
                      ls_bseg_doc-assignmentreference = ls_bseg-assignmentreference.
                      APPEND ls_bseg_doc TO lt_bseg_doc.
                    ENDLOOP.
                    SORT lt_bseg_doc BY buzei.

                    CLEAR lv_pos.
                    LOOP AT lt_bset_doc INTO ls_bset_pos.
                      IF ls_bset_pos-buzei = ls_bset-buzei.
                        lv_pos = sy-tabix.
                        EXIT.
                      ENDIF.
                    ENDLOOP.

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

                    IF lv_ita_found = abap_false AND lines( lt_bseg_doc ) = 1.
                      READ TABLE lt_bseg_doc INTO ls_bseg_doc INDEX 1.
                      ASSIGN COMPONENT lv_ita OF STRUCTURE ls_bseg_doc TO <fs_value>.
                      IF <fs_value> IS ASSIGNED AND <fs_value> EQ ls_map-kiril2.
                        lv_ita_found = abap_true.
                      ENDIF.
                      UNASSIGN <fs_value>.
                    ENDIF.

                  ENDIF.

                ELSE.
                  lv_ita_found = abap_true.
                ENDIF.

                CHECK lv_ita_found = abap_true.

                CLEAR ls_collect.
                ls_collect-kiril1 = ls_map-kiril1.
                ls_collect-acklm1 = ls_map-acklm1.
                ls_collect-matrah = ls_bset-hwbas.
                ls_collect-vergi  = ls_bset-hwste.
                ls_collect-islem_tur = ls_map-islem_tur.
                ls_collect-odeme_tur = ls_map-odeme_tur.
                COLLECT ls_collect INTO mt_collect.
                CLEAR ls_collect.

                CLEAR ls_collect.
                ls_collect-kiril1 = ls_map-kiril1.
                ls_collect-acklm1 = ls_map-acklm1.
                ls_collect-kiril2 = ls_map-kiril2.
                ls_collect-acklm2 = ls_map-acklm2.
                ls_collect-islem_tur = ls_map-islem_tur.
                ls_collect-odeme_tur = ls_map-odeme_tur.
                ls_collect-matrah = ls_bset-hwbas.
                ls_collect-vergi  = ls_bset-hwste.
                COLLECT ls_collect INTO mt_collect.
                CLEAR ls_collect.

                CLEAR ls_collect.
                ls_collect-kiril1 = ls_map-kiril1.
                ls_collect-acklm1 = ls_map-acklm1.
                ls_collect-kiril2 = ls_map-kiril2.
                ls_collect-acklm2 = ls_map-acklm2.
                ls_collect-kiril3 = ls_map-mwskz.
                CLEAR lv_oran_int.
                lv_oran_int = abs( ls_bset-kbetr ).
                ls_collect-oran = lv_oran_int.
                SHIFT ls_collect-oran LEFT DELETING LEADING space.
                ls_collect-matrah = ls_bset-hwbas.
                ls_collect-vergi  = ls_bset-hwste.
                ls_collect-islem_tur = ls_map-islem_tur.
                ls_collect-odeme_tur = ls_map-odeme_tur.
                COLLECT ls_collect INTO mt_collect.
                CLEAR ls_collect.

              ENDLOOP.

            ENDIF.

          ENDIF.

        WHEN '004'.
          READ TABLE lt_indirim INTO DATA(ls_indirim) WHERE hkont EQ ls_map-saknr.
          IF sy-subrc EQ 0.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-vergi  = ls_indirim-hwste.
            COLLECT ls_collect INTO mt_collect.

            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            COLLECT ls_collect INTO mt_collect.
          ELSE.
            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDIF.

        WHEN '010'.

          LOOP AT lt_ozel INTO DATA(ls_ozel) WHERE hkont = ls_map-saknr
                                               AND mwskz = ls_map-mwskz.

            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-matrah = ls_ozel-hwbas.
            ls_collect-vergi  = ls_ozel-hwste.
            ls_collect-islem_tur = ls_map-islem_tur.
            ls_collect-odeme_tur = ls_map-odeme_tur.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.

            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            ls_collect-matrah = ls_ozel-hwbas.
            ls_collect-vergi  = ls_ozel-hwste.
            ls_collect-islem_tur = ls_map-islem_tur.
            ls_collect-odeme_tur = ls_map-odeme_tur.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.

            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            ls_collect-kiril3 = ls_map-mwskz.
            CLEAR lv_oran_int.
            lv_oran_int = abs( ls_ozel-kbetr ).
            ls_collect-oran = lv_oran_int.
            SHIFT ls_collect-oran LEFT DELETING LEADING space.
            ls_collect-matrah = ls_ozel-hwbas.
            ls_collect-vergi  = ls_ozel-hwste.
            ls_collect-islem_tur = ls_map-islem_tur.
            ls_collect-odeme_tur = ls_map-odeme_tur.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDLOOP.

          IF sy-subrc IS NOT INITIAL.
            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril3 = ls_map-mwskz.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDIF.

        WHEN '011'.
          CLEAR lv_tabix.
          CLEAR ls_bseg.
          LOOP AT lt_bset INTO ls_bset WHERE hkont = ls_map-saknr
                                         AND mwskz = ls_map-mwskz
                                         AND blart = ls_map-blart
                                         AND bukrs = p_bukrs
                                         AND gjahr = p_gjahr.

            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-matrah = ls_bset-hwbas.
            ls_collect-vergi  = ls_bset-hwste.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.

            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            ls_collect-matrah = ls_bset-hwbas.
            ls_collect-vergi  = ls_bset-hwste.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.

            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            ls_collect-kiril3 = ls_map-mwskz.
            CLEAR lv_oran_int.
            lv_oran_int = abs( ls_bset-kbetr ).
            ls_collect-oran = lv_oran_int.
            SHIFT ls_collect-oran LEFT DELETING LEADING space.
            ls_collect-matrah = ls_bset-hwbas.
            ls_collect-vergi  = ls_bset-hwste.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDLOOP.
          IF sy-subrc IS NOT INITIAL.
            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril3 = ls_map-mwskz.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDIF.

        WHEN '012'.
          CLEAR lv_tabix.
          CLEAR ls_bseg.
          IF ls_map-kiril1 = '30'.
            LOOP AT lt_creditcart INTO DATA(ls_credit) WHERE hkont = ls_map-saknr
                                                         AND blart = ls_map-blart.
              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-matrah = ls_credit-tutar.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.
            ENDLOOP.
          ELSE.
            LOOP AT lt_bset INTO ls_bset WHERE hkont = ls_map-saknr
                                           AND blart = ls_map-blart.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-kiril2 = ls_map-kiril2.
              ls_collect-acklm2 = ls_map-acklm2.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-kiril2 = ls_map-kiril2.
              ls_collect-acklm2 = ls_map-acklm2.
              ls_collect-kiril3 = ls_map-mwskz.
              CLEAR lv_oran_int.
              lv_oran_int = abs( ls_bset-kbetr ).
              ls_collect-oran = lv_oran_int.
              SHIFT ls_collect-oran LEFT DELETING LEADING space.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.
            ENDLOOP.
          ENDIF.
          IF sy-subrc IS NOT INITIAL.
            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril3 = ls_map-mwskz.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDIF.

        WHEN '013'.
          CLEAR lv_tabix.
          CLEAR ls_bseg.
          IF ls_map-kiril1 = '99'.
            LOOP AT lt_bset INTO ls_bset WHERE blart = ls_map-blart.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              lv_oran_int = abs( ls_bset-kbetr ).
              ls_collect-oran = lv_oran_int.
              SHIFT ls_collect-oran LEFT DELETING LEADING space.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-kiril2 = ls_map-kiril2.
              ls_collect-acklm2 = ls_map-acklm2.
              lv_oran_int = abs( ls_bset-kbetr ).
              ls_collect-oran = lv_oran_int.
              SHIFT ls_collect-oran LEFT DELETING LEADING space.
              ls_collect-matrah = ls_bset-hwbas.
              ls_collect-vergi  = ls_bset-hwste.
              ls_collect-islem_tur = ls_map-islem_tur.
              ls_collect-odeme_tur = ls_map-odeme_tur.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.

              CLEAR ls_collect.
              ls_collect-kiril1 = ls_map-kiril1.
              ls_collect-acklm1 = ls_map-acklm1.
              ls_collect-kiril2 = ls_map-kiril2.
              ls_collect-acklm2 = ls_map-acklm2.
              ls_collect-kiril3 = ls_map-mwskz.
              ls_collect-islem_tur = ls_map-islem_tur.
              ls_collect-odeme_tur = ls_map-odeme_tur.
              CLEAR lv_oran_int.
              lv_oran_int = abs( ls_bset-kbetr ).
              ls_collect-oran = lv_oran_int.
              SHIFT ls_collect-oran LEFT DELETING LEADING space.
              ls_collect-matrah = ls_credit-tutar * -1.
              COLLECT ls_collect INTO mt_collect.
              CLEAR ls_collect.
            ENDLOOP.
          ENDIF.
          IF sy-subrc IS NOT INITIAL.
            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril3 = ls_map-mwskz.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDIF.

        WHEN '009'.

          DATA lt_bset_009 TYPE mtty_bset.
          CLEAR lt_bset_009.

          SELECT
            j~glaccount AS hkont,
            j~taxcode AS mwskz,
            j~accountingdocumenttype AS blart,
            SUM( j~amountincompanycodecurrency ) AS hwbas
            FROM i_journalentryitem AS j
            WHERE j~ledger        = '0L'
              AND j~companycode   = @p_bukrs
              AND j~fiscalyear    = @p_gjahr
              AND j~fiscalperiod  = @p_monat
              AND j~isreversal    = ''
              AND j~isreversed    = ''
              AND j~glaccount     = @ls_map-saknr
              AND ( j~financialaccounttype = 'S'
                 OR j~financialaccounttype = 'A' )
            GROUP BY j~glaccount, j~taxcode, j~accountingdocumenttype
            INTO CORRESPONDING FIELDS OF TABLE @lt_bset_009.

          LOOP AT lt_bset_009 INTO ls_bset.
            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-matrah = ls_bset-hwbas.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.

            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            ls_collect-matrah = ls_bset-hwbas.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.

            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            ls_collect-kiril3 = ls_bset-hkont.
            ls_collect-matrah = ls_bset-hwbas.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDLOOP.

          IF sy-subrc IS NOT INITIAL.
            CLEAR ls_collect.
            ls_collect-kiril1 = ls_map-kiril1.
            ls_collect-acklm1 = ls_map-acklm1.
            COLLECT ls_collect INTO mt_collect.
            ls_collect-kiril2 = ls_map-kiril2.
            ls_collect-acklm2 = ls_map-acklm2.
            COLLECT ls_collect INTO mt_collect.
            CLEAR ls_collect.
          ENDIF.

      ENDCASE.
    ENDLOOP.

    DATA lr_kiril3 TYPE RANGE OF ztax_e_acklm.
    lr_kiril3 = VALUE #(
      sign = 'I' option = 'EQ'
      ( low = 'T1' ) ( low = 'T2' ) ( low = 'T3' )
      ( low = 'T4' ) ( low = 'T5' ) ( low = 'T6' )
      ( low = 'T7' ) ( low = 'T8' ) ( low = 'T9' )
    ).

    LOOP AT mt_collect ASSIGNING <fs_collect>.
      <fs_collect>-matrah   = abs( <fs_collect>-matrah ).
      <fs_collect>-vergi    = abs( <fs_collect>-vergi ).
      <fs_collect>-tevkifat = abs( <fs_collect>-tevkifat ).

      IF <fs_collect>-kiril2 = '109'
        AND <fs_collect>-kiril3 IN lr_kiril3.
        READ TABLE lt_109 INTO DATA(ls_109_temp)
          WITH KEY mwskz = <fs_collect>-kiril3.
        IF sy-subrc EQ 0.
          <fs_collect>-vergi = abs( ls_109_temp-hwste ).
          <fs_collect>-matrah = <fs_collect>-matrah - <fs_collect>-vergi.
        ENDIF.
      ENDIF.
    ENDLOOP.

    DATA lv_109_toplam_matrah TYPE p LENGTH 16 DECIMALS 2.
    DATA lv_109_toplam_vergi  TYPE p LENGTH 16 DECIMALS 2.

    CLEAR lv_109_toplam_matrah.
    CLEAR lv_109_toplam_vergi.

    LOOP AT mt_collect INTO ls_collect
      WHERE kiril1 = '011'
        AND kiril2 = '109'
        AND kiril3 NE space.
      lv_109_toplam_matrah = lv_109_toplam_matrah + ls_collect-matrah.
      lv_109_toplam_vergi  = lv_109_toplam_vergi  + ls_collect-vergi.
    ENDLOOP.

    READ TABLE mt_collect ASSIGNING <fs_collect>
      WITH KEY kiril1 = '011'
               kiril2 = '109'
               kiril3 = space.
    IF <fs_collect> IS ASSIGNED.
      <fs_collect>-matrah = lv_109_toplam_matrah.
      <fs_collect>-vergi  = lv_109_toplam_vergi.
      UNASSIGN <fs_collect>.
    ENDIF.

    CLEAR ls_map.
    SORT lt_map BY kiril1 kiril2.
    LOOP AT lt_k1mt INTO ls_k1mt.

      CLEAR ls_map.
      READ TABLE lt_map INTO ls_map WITH KEY kiril1 = ls_k1mt-kiril1
                                             kiril2 = ls_k1mt-kiril2
                                             BINARY SEARCH.

      READ TABLE mt_collect ASSIGNING <fs_collect> WITH KEY kiril1 = ls_k1mt-kiril1
                                                            kiril2 = space.
      IF <fs_collect> IS ASSIGNED.
        <fs_collect>-matrah = <fs_collect>-matrah + ls_k1mt-matrah.
        <fs_collect>-vergi  = <fs_collect>-vergi + ls_k1mt-vergi.
        <fs_collect>-vergi  = <fs_collect>-vergi + ls_k1mt-tevkt.
        UNASSIGN <fs_collect>.
      ENDIF.

      READ TABLE mt_collect ASSIGNING <fs_collect> WITH KEY kiril1 = ls_k1mt-kiril1
                                                            kiril2 = ls_k1mt-kiril2.
      IF <fs_collect> IS ASSIGNED.
        <fs_collect>-matrah = <fs_collect>-matrah + ls_k1mt-matrah.
        <fs_collect>-vergi  = <fs_collect>-vergi + ls_k1mt-vergi.
        <fs_collect>-vergi  = <fs_collect>-vergi + ls_k1mt-tevkt.
        UNASSIGN <fs_collect>.
      ENDIF.

      READ TABLE mt_collect ASSIGNING <fs_collect> WITH KEY kiril1 = ls_k1mt-kiril1
                                                            kiril2 = ls_k1mt-kiril2
                                                            kiril3 = ls_k1mt-mwskz.
      IF <fs_collect> IS ASSIGNED.
        <fs_collect>-matrah = <fs_collect>-matrah + ls_k1mt-matrah.
        <fs_collect>-vergi  = <fs_collect>-vergi + ls_k1mt-vergi.
        <fs_collect>-vergi  = <fs_collect>-vergi + ls_k1mt-tevkt.
        UNASSIGN <fs_collect>.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_map INTO ls_map WHERE topal NE space.

      CONDENSE ls_map-topal NO-GAPS.
      CLEAR lt_topal.
      CLEAR lv_kiril2.
      CLEAR lv_kiril1.
      SPLIT ls_map-topal AT '+' INTO TABLE lt_topal.

      LOOP AT lt_topal INTO ls_topal.
        lv_kiril2 = '000'.
        SHIFT ls_topal-split LEFT DELETING LEADING space.
        lv_kiril1 = ls_topal-split.

        LOOP AT mt_collect INTO ls_collect WHERE kiril1 EQ lv_kiril1
                                             AND kiril2 EQ lv_kiril2
                                             AND kiril3 EQ space.
          CLEAR : ls_collect-islem_tur.
          ls_collect-kiril1 = ls_map-kiril1.
          ls_collect-acklm1 = ls_map-acklm1.
          ls_collect-kiril2 = ls_map-kiril2.
          ls_collect-acklm2 = ls_map-acklm2.

          IF ls_map-topalk EQ '001'.
            CLEAR ls_collect-matrah.
            CLEAR ls_collect-oran.
            CLEAR ls_collect-tevkifat.
            CLEAR ls_collect-tevkifato.
          ELSE.
            CLEAR ls_collect-vergi.
            CLEAR ls_collect-tevkifat.
          ENDIF.

          COLLECT ls_collect INTO mt_collect.
          CLEAR ls_collect.
        ENDLOOP.
      ENDLOOP.

      IF ls_map-kural EQ '007'.
        READ TABLE mt_collect ASSIGNING <fs_collect> WITH KEY kiril1 = ls_map-kiril1
                                                              kiril2 = ls_map-kiril2.
        IF sy-subrc IS INITIAL.
          <fs_collect>-matrah = <fs_collect>-matrah + lv_thlog_wrbtr.
          UNASSIGN <fs_collect>.
        ENDIF.
      ENDIF.
    ENDLOOP.

    et_collect = mt_collect.
    er_monat   = mr_monat.

  ENDMETHOD.
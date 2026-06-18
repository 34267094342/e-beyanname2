  METHOD kesinti.

    TYPES BEGIN OF lty_lfa1.
    TYPES lifnr TYPE lifnr.
    TYPES name1 TYPE c LENGTH 100.
*    TYPES name2 TYPE lfa1-name2.
    TYPES mcod1 TYPE c LENGTH 25.
    TYPES stcd2 TYPE stcd2.
    TYPES land1 TYPE land1.
    TYPES END OF lty_lfa1.

    TYPES BEGIN OF lty_odt.
    TYPES odmtr TYPE c LENGTH 1."/itetr/tax_k2odt-odmtr.
    TYPES acklm TYPE c LENGTH 1.
    TYPES END OF lty_odt.

    TYPES BEGIN OF lty_k2.
    TYPES kiril2 TYPE ztax_t_k2k2-kiril2.
    TYPES acklm  TYPE ztax_t_k2k2-acklm.
    TYPES END OF lty_k2.

    TYPES: BEGIN OF ty_sum_kesinti,
             belnr  TYPE ztax_ddl_i_vat2_kes_report-belnr,
             matrah TYPE ztax_ddl_i_vat2_kes_report-matrah,
             vergi  TYPE ztax_ddl_i_vat2_kes_report-vergi,
             tevkt  TYPE ztax_ddl_i_vat2_kes_report-tevkt,
           END OF ty_sum_kesinti.




    DATA lt_belnr_sum_kesinti TYPE TABLE OF ty_sum_kesinti.
    DATA ls_belnr_sum_kesinti TYPE ty_sum_kesinti.

    DATA ls_bkpf TYPE mty_bkpf.
    DATA lt_bkpf TYPE SORTED TABLE OF mty_bkpf WITH UNIQUE KEY bukrs belnr gjahr.
    DATA lt_bseg_koart_k TYPE TABLE OF mty_bseg .
    DATA ls_bseg_koart_k TYPE mty_bseg.
    DATA lt_bset TYPE mtty_bset.
    DATA lt_bset_bs TYPE TABLE OF mty_bset.
    DATA ls_bset TYPE mty_bset.
    DATA ls_bseg TYPE mty_bseg.
    DATA lt_bseg TYPE mtty_bseg.
    DATA ls_read_tab  TYPE mty_read_tab.
    DATA lr_mwskz TYPE mtty_mwskz_range.
    DATA lt_belnr TYPE mtty_bseg.
    DATA ls_belnr TYPE mty_bseg.
    DATA lt_lifnr TYPE TABLE OF mty_bseg.
    DATA lt_odt   TYPE TABLE OF lty_odt.
    DATA ls_odt   TYPE lty_odt.
    DATA ls_kesinti    TYPE ztax_ddl_i_vat2_kes_report.
    DATA lv_odmtr      TYPE ztax_ddl_i_vat2_kes_report-odmtr.
    DATA lt_bseg_tax   TYPE TABLE OF mty_bseg.
    DATA ls_bseg_tax   TYPE mty_bseg.
    DATA lv_ita        TYPE ztax_t_k2ita-fieldname.
    DATA lv_tabix      TYPE sy-tabix.
    DATA lv_mwskz      TYPE mwskz.
    DATA lt_hesap      TYPE mtty_hesap.
    DATA lt_parameters TYPE mtty_hesap.
    DATA ls_collect    TYPE mty_collect.
    DATA lv_butxt      TYPE butxt.
    DATA lt_k2mt       TYPE TABLE OF ztax_t_k2mt.
    DATA ls_k2mt       TYPE ztax_t_k2mt.
    DATA lv_kiril2     TYPE ztax_t_k2k2-kiril2.
    DATA lt_k2 TYPE TABLE OF lty_k2.
    DATA ls_k2 TYPE lty_k2.

    DATA ls_lfa1              TYPE lty_lfa1.
    DATA lt_lfa1              TYPE SORTED TABLE OF lty_lfa1 WITH UNIQUE KEY lifnr.
    DATA lt_lfa1_man          TYPE SORTED TABLE OF lty_lfa1 WITH UNIQUE KEY lifnr.
    DATA lt_lifnr_man         TYPE TABLE OF ztax_t_k2mt.

    FIELD-SYMBOLS <fs_parameter> TYPE mty_hesap.
    FIELD-SYMBOLS <fs_kesinti>   TYPE ztax_ddl_i_vat2_kes_report.
    FIELD-SYMBOLS <fs_ita> TYPE any.


    CLEAR me->ms_button_pushed.
    me->ms_button_pushed-kes = abap_true.

    CLEAR mt_kesinti.

    SELECT SINGLE companycodename AS butxt
           FROM i_companycode
           WHERE companycode EQ @p_bukrs
           INTO @lv_butxt.

    CLEAR ls_read_tab.
    ls_read_tab-bset = abap_true.
    ls_read_tab-bseg = abap_true.
*    me->find_document( EXPORTING is_read_tab = ls_read_tab
*                                 ir_mwskz    = mr_mwskz
*                                 ir_kschl    = mr_kschl
*                       IMPORTING et_bkpf     = lt_bkpf
*                                 et_bset     = lt_bset
*                                 et_bseg     = lt_bseg ).
    MOVE-CORRESPONDING mt_bkpf[] TO lt_bkpf[].
    MOVE-CORRESPONDING mt_bset[] TO lt_bset[].
    MOVE-CORRESPONDING mt_bseg[] TO lt_bseg[].
    "GIB Tabloları
    SELECT *
           FROM ztax_t_gib
           INTO TABLE @DATA(lt_gib).

    SELECT k2type,
           mwskz
           FROM ztax_t_k2ist
           INTO TABLE @DATA(lt_ist).


    SELECT *
      FROM ztax_t_k2mt
      WHERE bukrs EQ @p_bukrs
        AND gjahr EQ @p_gjahr
        AND monat IN @mr_monat
        AND mwskz IN @mr_mwskz
        INTO TABLE @lt_k2mt.

    lt_lifnr_man = lt_k2mt.
    DELETE lt_lifnr_man WHERE lifnr EQ space.
    SORT lt_lifnr_man BY lifnr.
    DELETE ADJACENT DUPLICATES FROM lt_lifnr_man COMPARING lifnr.
    IF lines( lt_lifnr_man ) GT 0.
      SELECT supplier AS lifnr,
             suppliername AS name1,
*             CustomerName as name2,
             addresssearchterm1 AS mcod1,
             taxnumber2 AS stcd2,
             country AS land1

             FROM i_supplier
            INNER JOIN @lt_lifnr_man AS man
             ON supplier EQ man~lifnr
                INTO TABLE @lt_lfa1_man.
    ENDIF.

    CLEAR lt_bseg_koart_k.
    lt_bseg_koart_k = lt_bseg.
    DELETE lt_bseg_koart_k WHERE koart NE 'K'.

    lt_belnr = lt_bseg_koart_k.
    SORT lt_belnr BY bukrs belnr gjahr.
    DELETE ADJACENT DUPLICATES FROM lt_belnr COMPARING bukrs belnr gjahr.

    lt_lifnr = lt_bseg_koart_k.
    SORT lt_lifnr BY lifnr.
    DELETE ADJACENT DUPLICATES FROM lt_lifnr COMPARING lifnr.

    IF lines( lt_lifnr ) GT 0.

      SELECT supplier AS lifnr,
             suppliername AS name1,
*             CustomerName as name2,
             addresssearchterm1 AS mcod1,
             taxnumber2 AS stcd2,
             country AS land1
             FROM i_supplier
             INNER JOIN @lt_lifnr AS lifnr
             ON supplier EQ lifnr~lifnr
             INTO TABLE @lt_lfa1.

    ENDIF.


    lt_bset_bs = lt_bset.
    SORT lt_bset_bs BY bukrs belnr gjahr mwskz ASCENDING.

    SELECT odmtr,
           acklm
           FROM ztax_t_k2odt
           INTO TABLE @lt_odt.

    SORT lt_odt BY odmtr.
    SORT lt_bseg_koart_k BY bukrs belnr gjahr.

*    lt_bseg_tax = lt_bseg.
    MOVE-CORRESPONDING lt_bseg TO lt_bseg_tax.

*    DELETE lt_bseg_tax WHERE buzid NE 'T'. "YiğitcanÖzdemir

    SORT lt_bseg_tax BY bukrs belnr gjahr mwskz.

    SELECT kiril2,
           acklm
           FROM ztax_t_k2k2
           INTO TABLE @lt_k2.

    SORT lt_k2 BY kiril2.

    SELECT SINGLE fieldname

           FROM ztax_t_k2ita
           INTO @lv_ita.

*    lt_hesap = mt_hesap.
    MOVE-CORRESPONDING mt_hesap TO lt_hesap.

    DELETE lt_hesap WHERE hesaptip NE '001'
                      AND hesaptip NE '004'
                      AND hesaptip NE '005'.

    lt_parameters = lt_hesap.
    SORT lt_parameters BY hesaptip ASCENDING kschl.
    DELETE ADJACENT DUPLICATES FROM lt_parameters COMPARING hesaptip kschl.

    me->filter_kschl_from_formul( CHANGING ct_hesap = lt_hesap ).

    SORT lt_hesap BY hesaptip ASCENDING kschl.
    DELETE ADJACENT DUPLICATES FROM lt_hesap COMPARING hesaptip kschl.

    CLEAR lt_parameters.
*    lt_parameters = lt_hesap.

    MOVE-CORRESPONDING lt_hesap TO lt_parameters.

    SORT lt_parameters BY kschl.
    DELETE ADJACENT DUPLICATES FROM lt_parameters COMPARING kschl.

    LOOP AT lt_belnr INTO ls_belnr.

      CLEAR ls_bseg_koart_k.
      READ TABLE lt_bseg_koart_k INTO ls_bseg_koart_k WITH KEY bukrs = ls_belnr-bukrs
                                                               belnr = ls_belnr-belnr
                                                               gjahr = ls_belnr-gjahr
                                                               BINARY SEARCH.
      CLEAR ls_lfa1.
      CLEAR lv_odmtr.
      READ TABLE lt_lfa1 INTO ls_lfa1 WITH TABLE KEY lifnr = ls_bseg_koart_k-lifnr.
      CASE ls_lfa1-land1.
        WHEN 'TR'.
          lv_odmtr = '102'.
        WHEN OTHERS.
          lv_odmtr = '101'.
      ENDCASE.

      CLEAR ls_bkpf.
      READ TABLE lt_bkpf INTO ls_bkpf WITH TABLE KEY bukrs = ls_belnr-bukrs
                                                     belnr = ls_belnr-belnr
                                                     gjahr = ls_belnr-gjahr.

      CLEAR ls_odt.
      READ TABLE lt_odt INTO ls_odt WITH KEY odmtr = lv_odmtr BINARY SEARCH.

      READ TABLE lt_bset_bs TRANSPORTING NO FIELDS WITH KEY bukrs = ls_belnr-bukrs
                                                            belnr = ls_belnr-belnr
                                                            gjahr = ls_belnr-gjahr
                                                            BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        CLEAR lt_parameters.
        CLEAR lv_mwskz.
        CLEAR ls_k2.
        LOOP AT lt_bset_bs INTO ls_bset FROM sy-tabix.

          IF ls_bset-bukrs NE ls_belnr-bukrs OR
             ls_bset-belnr NE ls_belnr-belnr OR
             ls_bset-gjahr NE ls_belnr-gjahr.
            EXIT.
          ENDIF.

*          CASE lv_mwskz.
*            WHEN ls_bset-mwskz.
          "do nothing
*            WHEN OTHERS.
          CLEAR ls_bseg_tax.
          CLEAR lv_tabix.
          READ TABLE lt_bseg_tax INTO ls_bseg_tax WITH KEY bukrs = ls_bset-bukrs
                                                           belnr = ls_bset-belnr
                                                           gjahr = ls_bset-gjahr
                                                           mwskz = ls_bset-mwskz
                                                           BINARY SEARCH.
          lv_tabix = sy-tabix.
          CLEAR: ls_k2 , lv_kiril2.
          LOOP AT lt_gib INTO DATA(ls_gib).
            ASSIGN COMPONENT ls_gib-alan OF STRUCTURE ls_bseg_tax TO <fs_ita>.
            IF sy-subrc EQ 0.
              lv_kiril2 = <fs_ita>.
              EXIT.
            ENDIF.
          ENDLOOP.
          IF <fs_ita> IS NOT ASSIGNED.
            ASSIGN COMPONENT lv_ita OF STRUCTURE ls_bseg_tax TO <fs_ita>.
            IF sy-subrc EQ 0.
              lv_kiril2 = <fs_ita>.
            ENDIF.
          ENDIF.
          IF <fs_ita> IS NOT ASSIGNED.
            READ TABLE lt_ist INTO DATA(ls_ist) WITH KEY mwskz = ls_bseg_tax-mwskz.
            IF sy-subrc EQ 0.
              lv_kiril2 = ls_ist-k2type.
            ENDIF.
*                ASSIGN COMPONENT ls_ist-k2type OF STRUCTURE ls_bseg_tax TO <fs_ita>.
          ENDIF.
*              IF <fs_ita> IS ASSIGNED.
          IF lv_kiril2 IS NOT INITIAL.
            READ TABLE lt_k2 INTO ls_k2 WITH KEY kiril2 = lv_kiril2 BINARY SEARCH.
*                READ TABLE lt_k2 INTO ls_k2 WITH KEY kiril2 = <fs_ita> BINARY SEARCH.
            IF sy-subrc IS NOT INITIAL.
*              ADD 1 TO lv_tabix.
              lv_tabix = lv_tabix + 1.
              LOOP AT lt_bseg_tax INTO ls_bseg_tax FROM lv_tabix.
                IF ls_bseg_tax-bukrs NE ls_bset-bukrs OR
                   ls_bseg_tax-belnr NE ls_bset-belnr OR
                   ls_bseg_tax-gjahr NE ls_bset-gjahr OR
                   ls_bseg_tax-mwskz NE ls_bset-mwskz.
                  EXIT.
                ENDIF.
                lv_tabix = sy-tabix.
                CLEAR ls_k2.
                READ TABLE lt_k2 INTO ls_k2 WITH KEY kiril2 = lv_kiril2 BINARY SEARCH.
                IF sy-subrc IS INITIAL.
                  EXIT.
                ENDIF.
              ENDLOOP.
            ENDIF.
*                UNASSIGN <fs_ita>.
          ENDIF.
*              CLEAR ls_k2.
*              ASSIGN COMPONENT lv_ita OF STRUCTURE ls_bseg_tax TO <fs_ita>.
*              IF sy-subrc IS INITIAL.
*                READ TABLE lt_k2 INTO ls_k2 WITH KEY kiril2 = <fs_ita> BINARY SEARCH.
*                IF sy-subrc IS NOT INITIAL.
*                  ADD 1 TO lv_tabix.
*                  LOOP AT lt_bseg_tax INTO ls_bseg_tax FROM lv_tabix.
*                    IF ls_bseg_tax-bukrs NE ls_bset-bukrs OR
*                       ls_bseg_tax-belnr NE ls_bset-belnr OR
*                       ls_bseg_tax-gjahr NE ls_bset-gjahr OR
*                       ls_bseg_tax-mwskz NE ls_bset-mwskz.
*                      EXIT.
*                    ENDIF.
*                    lv_tabix = sy-tabix.
*                    CLEAR ls_k2.
*                    READ TABLE lt_k2 INTO ls_k2 WITH KEY kiril2 = <fs_ita> BINARY SEARCH.
*                    IF sy-subrc IS INITIAL.
*                      EXIT.
*                    ENDIF.
*                  ENDLOOP.
*                ENDIF.
*                UNASSIGN <fs_ita>.
*              ENDIF.
*          ENDCASE.

          CHECK ls_k2-kiril2 NE '000'.

*          CASE lv_mwskz.
*            WHEN ls_bset-mwskz.
*
*            WHEN OTHERS.
*              IF lv_mwskz NE space.
          IF ls_bset-mwskz NE space.
            IF <fs_kesinti> IS ASSIGNED.
              CLEAR ls_collect.
              me->fill_amount_fields( EXPORTING it_hesap       = lt_hesap
                                                 it_parameters = lt_parameters
                                       CHANGING  cs_collect    = ls_collect ).
              <fs_kesinti>-matrah = ls_collect-matrah.
              <fs_kesinti>-vergi  = ls_collect-vergi.
              <fs_kesinti>-tevkt  = abs( ls_collect-tevkifat ).
              <fs_kesinti>-oran   = ls_collect-oran.
              <fs_kesinti>-tevkt_oran  = ls_collect-tevkifato.
              CLEAR lt_parameters.
              READ TABLE lt_ist INTO ls_ist WITH KEY mwskz = ls_bset-mwskz.
              IF sy-subrc EQ 0.
                <fs_kesinti>-islem_tur = ls_ist-k2type.
              ENDIF.
              UNASSIGN <fs_kesinti>.
            ENDIF.
          ENDIF.

          CLEAR ls_kesinti.
          ls_kesinti-bukrs   = ls_bset-bukrs.
          ls_kesinti-butxt   = lv_butxt.
          ls_kesinti-belnr   = ls_bset-belnr.
          ls_kesinti-gjahr   = ls_bset-gjahr.
          ls_kesinti-lifnr   = ls_lfa1-lifnr.
          ls_kesinti-monat   = ls_bkpf-monat.
          ls_kesinti-name1   = ls_lfa1-name1.
*          ls_kesinti-name2   = ls_lfa1-name2.
          ls_kesinti-mcod1   = ls_lfa1-mcod1.
          CASE strlen( ls_lfa1-stcd2 ).
            WHEN 11.
              ls_kesinti-tckn    = ls_lfa1-stcd2.
            WHEN 10.
              ls_kesinti-vkn     = ls_lfa1-stcd2.
          ENDCASE.
          ls_kesinti-mwskz   = ls_bset-mwskz.
          ls_kesinti-kiril2  = ls_k2-kiril2.
          ls_kesinti-acklm2  = ls_k2-acklm.
          ls_kesinti-odmtr   = ls_odt-odmtr.
          ls_kesinti-acklmot = ls_odt-acklm.
*          me->close_fields( CHANGING ct_cell_tab = ls_kesinti-cell_tab ).
          APPEND ls_kesinti TO mt_kesinti ASSIGNING <fs_kesinti>.
          CLEAR ls_kesinti.
*          ENDCASE.

          READ TABLE lt_parameters ASSIGNING <fs_parameter> WITH KEY kschl = ls_bset-kschl.
          IF <fs_parameter> IS ASSIGNED.
*            ADD ls_bset-hwbas TO <fs_parameter>-amount.
            <fs_parameter>-amount =  <fs_parameter>-amount + ls_bset-hwbas.
*            ADD ls_bset-hwste TO <fs_parameter>-tax.
            <fs_parameter>-tax = <fs_parameter>-tax + ls_bset-hwste.
            UNASSIGN <fs_parameter>.
          ELSE.
            APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_parameter>.
            IF <fs_parameter> IS ASSIGNED.
              <fs_parameter>-kschl  = ls_bset-kschl.
              <fs_parameter>-amount = ls_bset-hwbas.
              <fs_parameter>-tax    = ls_bset-hwste.
              UNASSIGN <fs_parameter>.
            ENDIF.
          ENDIF.
          lv_mwskz = ls_bset-mwskz.
        ENDLOOP.

        IF lines( lt_parameters ) GT 0.
          IF <fs_kesinti> IS ASSIGNED.
            CLEAR ls_collect.
            me->fill_amount_fields( EXPORTING it_hesap       = lt_hesap
                                               it_parameters = lt_parameters
                                     CHANGING  cs_collect    = ls_collect ).
            <fs_kesinti>-matrah = ls_collect-matrah.
            <fs_kesinti>-vergi  = ls_collect-vergi.
            <fs_kesinti>-tevkt  = abs( ls_collect-tevkifat ).
            <fs_kesinti>-oran   = ls_collect-oran.
            <fs_kesinti>-tevkt_oran  = ls_collect-tevkifato.
            CLEAR ls_ist.
*            READ TABLE lt_ist INTO ls_ist WITH KEY mwskz = ls_bset-mwskz.
            READ TABLE lt_ist INTO ls_ist WITH KEY mwskz = lv_mwskz."Alper NANTU 10.12.2025
            IF sy-subrc EQ 0.
              <fs_kesinti>-islem_tur = ls_ist-k2type.
            ENDIF.
            CLEAR lt_parameters.
            UNASSIGN <fs_kesinti>.
          ENDIF.
          CLEAR lt_parameters.
        ENDIF.
      ENDIF.
    ENDLOOP.


    LOOP AT lt_k2mt INTO ls_k2mt.

      CLEAR ls_k2.
      READ TABLE lt_k2 INTO ls_k2 WITH KEY kiril2 = ls_k2mt-k2type BINARY SEARCH.

      CLEAR ls_odt.
      READ TABLE lt_odt INTO ls_odt WITH KEY odmtr = ls_k2mt-odmtr BINARY SEARCH.

      CLEAR ls_lfa1.
      READ TABLE lt_lfa1_man INTO ls_lfa1 WITH TABLE KEY lifnr = ls_k2mt-lifnr.

      APPEND INITIAL LINE TO mt_kesinti ASSIGNING <fs_kesinti>.
      IF <fs_kesinti> IS ASSIGNED.
        <fs_kesinti>-bukrs  = ls_k2mt-bukrs.
        <fs_kesinti>-butxt  = lv_butxt.
        <fs_kesinti>-belnr  = mc_new_line_belnr.
        <fs_kesinti>-monat  = ls_k2mt-monat.
        <fs_kesinti>-gjahr  = ls_k2mt-gjahr.
        <fs_kesinti>-lifnr  = ls_k2mt-lifnr.
        IF <fs_kesinti>-lifnr  EQ space.
          <fs_kesinti>-name1  = ls_k2mt-name1.
          <fs_kesinti>-name2  = ls_k2mt-name2.
          <fs_kesinti>-sosg   = abap_true.
        ELSE.
          <fs_kesinti>-name1  = ls_lfa1-name1.
*          <fs_kesinti>-name2  = ls_lfa1-name2.
          <fs_kesinti>-mcod1  = ls_lfa1-mcod1.
          <fs_kesinti>-sosg   = space.
        ENDIF.
        <fs_kesinti>-tckn    = ls_k2mt-tckn.
        <fs_kesinti>-vkn     = ls_k2mt-vkn.
        <fs_kesinti>-matrah  = ls_k2mt-matrah.
        <fs_kesinti>-vergi   = ls_k2mt-vergi.
        <fs_kesinti>-tevkt   = abs( ls_k2mt-tevkt ).
        <fs_kesinti>-mwskz   = ls_k2mt-mwskz.
        <fs_kesinti>-kiril2  = ls_k2mt-k2type.
        <fs_kesinti>-acklm2  = ls_k2-acklm.
        <fs_kesinti>-odmtr   = ls_k2mt-odmtr.
        <fs_kesinti>-acklmot = ls_odt-acklm.
        <fs_kesinti>-buzei   = ls_k2mt-buzei.
        <fs_kesinti>-manuel   = ls_k2mt-manuel.
        <fs_kesinti>-vergidis = ls_k2mt-vergidis.
        <fs_kesinti>-vergiic  = ls_k2mt-vergiic.
*        <fs_kesinti>-row_color = mc_new_line_color.
*        me->close_fields( CHANGING ct_cell_tab = <fs_kesinti>-cell_tab ).

      ENDIF.

    ENDLOOP.

    LOOP AT mt_kesinti INTO ls_kesinti.
      MOVE-CORRESPONDING ls_kesinti TO ls_belnr_sum_kesinti.
      COLLECT ls_belnr_sum_kesinti INTO lt_belnr_sum_kesinti.
    ENDLOOP.

    SORT mt_kesinti ASCENDING BY belnr.
    SORT lt_belnr_sum_kesinti ASCENDING BY belnr.
    DELETE ADJACENT DUPLICATES FROM mt_kesinti COMPARING belnr.

    LOOP AT mt_kesinti ASSIGNING FIELD-SYMBOL(<ls_kesinti>).
      READ TABLE lt_belnr_sum_kesinti INTO DATA(ls_belnr_kesinti) WITH KEY belnr = <ls_kesinti>-belnr
                                                                           BINARY SEARCH.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_belnr_kesinti TO <ls_kesinti>.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
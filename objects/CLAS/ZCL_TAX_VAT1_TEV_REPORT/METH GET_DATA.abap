  METHOD get_data.


    FIELD-SYMBOLS <fs_value>     TYPE any.
    FIELD-SYMBOLS <fs_value_dyn> TYPE any.


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

    me->fill_monat_range( ).
    me->get_map_tab( IMPORTING et_map = lt_map ).
    me->fill_mwskz( EXPORTING it_map   = lt_map
                    IMPORTING er_mwskz = lr_mwskz ).

    me->get_fieldname( IMPORTING et_tevita = mt_tevita ).

*        ASSIGN lo_data->* TO <fs_out_tev>.
*        CREATE DATA lo_data_line LIKE LINE OF <fs_out_tev>.
*        DATA : lo_data_line LIKE LINE OF <fs_out_tev>.
*        ASSIGN lo_data_line->* TO <fs_line>.

    TYPES: BEGIN OF ty_output_line,
             belnr     TYPE belnr_d,
             bukrs     TYPE bukrs,
             gjahr     TYPE gjahr,
             bldat     TYPE bldat,
             serino    TYPE string,
             sirano    TYPE string,
             stcd2     TYPE string,
             name1     TYPE string,
             name2     TYPE string,
             matrah    TYPE wrbtr,
             heskdv    TYPE wrbtr,
             vergi     TYPE wrbtr,
             kbetr     TYPE int4,
             mwskz     TYPE mwskz,
             tevkifato TYPE string,
           END OF ty_output_line.

*DATA lt_out TYPE STANDARD TABLE OF ty_output_line.
*DATA ls_out TYPE ty_output_line.
    FIELD-SYMBOLS: <fs_line>    TYPE ty_output_line,
                   <fs_out_tev> TYPE STANDARD TABLE.  " SAP Cloud uyumlu

    DATA lt_temp TYPE STANDARD TABLE OF ty_output_line WITH EMPTY KEY.

    ASSIGN lt_temp TO <fs_out_tev>.

    DATA(lo_data_line) = NEW ty_output_line( ).
    ASSIGN lo_data_line->* TO <fs_line>.

*        DATA(lo_data) = NEW ty_output_line( ).   " bir satır örnek için
*        DATA lt_temp TYPE STANDARD TABLE OF ty_output_line.
*        ASSIGN lt_temp TO <fs_out_tev>.          " Artık <fs_out_tev> tabloya bağlandı

    CLEAR ls_read_tab.
    ls_read_tab-bset = abap_true.
    ls_read_tab-bseg = abap_true.

    me->find_document(  EXPORTING is_read_tab = ls_read_tab
                                  ir_mwskz    = lr_mwskz
                        IMPORTING et_bkpf     = lt_bkpf
                                  et_bset     = lt_bset
                                  et_bseg     = lt_bseg ).

    CLEAR lt_belnr.
    lt_belnr = lt_bset.

    SORT lt_belnr BY belnr bukrs gjahr.
    DELETE ADJACENT DUPLICATES FROM lt_belnr COMPARING belnr bukrs gjahr.

    INSERT LINES OF lt_bseg INTO TABLE lt_bseg_koart.
    DELETE lt_bseg_koart WHERE FinancialAccountType EQ space.
    DELETE lt_bseg_koart WHERE customer EQ space.

    INSERT LINES OF lt_bseg INTO TABLE lt_bseg_buzid.
    DELETE lt_bseg_buzid WHERE AccountingDocumentItemType NE 'T' OR DebitCreditCode NE 'H'.

    CLEAR lt_kunnr.
    lt_kunnr = lt_bseg.
    DELETE lt_kunnr WHERE Customer EQ space.
    SORT lt_kunnr BY Customer.
    DELETE ADJACENT DUPLICATES FROM lt_kunnr COMPARING Customer.

    IF lines( lt_kunnr ) GT 0.

      SELECT Customer ,
             OrganizationBPName1 ,
             OrganizationBPName2 ,
             TaxNumber2
             FROM i_customer
             FOR ALL ENTRIES IN @lt_kunnr
             WHERE Customer EQ @lt_kunnr-Customer
             INTO TABLE @lt_kna1.

    ENDIF.

    CLEAR lt_lifnr.
    lt_lifnr = lt_bseg.
    DELETE lt_lifnr WHERE Supplier EQ space.
    SORT lt_lifnr BY Supplier.
    DELETE ADJACENT DUPLICATES FROM lt_lifnr COMPARING Supplier.

    IF lines( lt_lifnr ) GT 0.

      SELECT Supplier ,
             OrganizationBPName1 ,
             OrganizationBPName2 ,
             TaxNumber2
             FROM i_supplier
             FOR ALL ENTRIES IN @lt_lifnr
             WHERE Supplier EQ @lt_lifnr-Supplier
             INTO TABLE @lt_lfa1.

    ENDIF.
    DATA ls_tax_voran TYPE  ztax_t_voran.
    DATA lv_hwste TYPE p LENGTH 16 DECIMALS 2.

    LOOP AT lt_belnr INTO ls_belnr.
      CLEAR ls_tax_voran.
      CLEAR lv_hwste.
      SELECT SINGLE * FROM ztax_t_voran
        WHERE bukrs EQ @p_bukrs
          AND mwskz EQ @ls_belnr-mwskz
          INTO @ls_tax_voran.

      CLEAR ls_tevkifat.
*          CLEAR <fs_line>.
      CLEAR ls_bkpf.
      CLEAR lt_split.
      CLEAR ls_split.
      CLEAR ls_tevita.
      CLEAR lv_percent_s.
      CLEAR lv_percent_h.

      ASSIGN COMPONENT 'BELNR' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = ls_belnr-belnr.
        UNASSIGN <fs_value>.
      ENDIF.

      ASSIGN COMPONENT 'BUKRS' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = ls_belnr-bukrs.
        UNASSIGN <fs_value>.
      ENDIF.

      ASSIGN COMPONENT 'GJAHR' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = ls_belnr-gjahr.
        UNASSIGN <fs_value>.
      ENDIF.

      READ TABLE lt_bkpf INTO ls_bkpf WITH  KEY bukrs = ls_belnr-bukrs
                                                     belnr = ls_belnr-belnr
                                                     gjahr = ls_belnr-gjahr.
      ASSIGN COMPONENT 'BLDAT' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = ls_bkpf-bldat.
        UNASSIGN <fs_value>.
      ENDIF.

      IF ls_bkpf-xblnr CA mc_hyphen.
        SPLIT ls_bkpf-xblnr AT mc_hyphen INTO TABLE lt_split.

        CLEAR ls_split.
        READ TABLE lt_split INTO ls_split INDEX 1.
        IF sy-subrc IS INITIAL.
          ASSIGN COMPONENT 'SERINO' OF STRUCTURE <fs_line> TO <fs_value>.
          IF <fs_value> IS ASSIGNED.
            <fs_value> = ls_split-value.
            UNASSIGN <fs_value>.
          ENDIF.
        ENDIF.
        CLEAR ls_split.
        READ TABLE lt_split INTO ls_split INDEX 2.
        IF sy-subrc IS INITIAL.
          ASSIGN COMPONENT 'SIRANO' OF STRUCTURE <fs_line> TO <fs_value>.
          IF <fs_value> IS ASSIGNED.
            <fs_value> = ls_split-value.
            UNASSIGN <fs_value>.
          ENDIF.
        ENDIF.
      ELSE.
        ASSIGN COMPONENT 'SIRANO' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_bkpf-xblnr.
          UNASSIGN <fs_value>.
        ENDIF.
      ENDIF.

      CLEAR ls_bseg.
      READ TABLE lt_bseg_koart INTO ls_bseg WITH  KEY CompanyCode        = ls_belnr-bukrs
                                                           AccountingDocument = ls_belnr-belnr
                                                           FiscalYear         = ls_belnr-gjahr.
      IF ls_bseg-FinancialAccountType EQ 'D'.
        CLEAR ls_kna1.
        READ TABLE lt_kna1 INTO ls_kna1 WITH  KEY kunnr = ls_bseg-Customer.
        ASSIGN COMPONENT 'STCD2' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_kna1-stcd2.
          UNASSIGN <fs_value>.
        ENDIF.
        ASSIGN COMPONENT 'NAME1' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_kna1-name1.
          UNASSIGN <fs_value>.
        ENDIF.
        ASSIGN COMPONENT 'NAME2' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_kna1-name2.
          UNASSIGN <fs_value>.
        ENDIF.
        ELSEIF ls_bseg-FinancialAccountType EQ 'S'. "YiğitcanÖzdemir
        CLEAR ls_kna1.
        READ TABLE lt_kna1 INTO ls_kna1 WITH  KEY kunnr = ls_bseg-Customer.
        ASSIGN COMPONENT 'STCD2' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_kna1-stcd2.
          UNASSIGN <fs_value>.
        ENDIF.
        ASSIGN COMPONENT 'NAME1' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_kna1-name1.
          UNASSIGN <fs_value>.
        ENDIF.
        ASSIGN COMPONENT 'NAME2' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_kna1-name2.
          UNASSIGN <fs_value>.
        ENDIF.
      ELSEIF ls_bseg-FinancialAccountType EQ 'K'.
        CLEAR ls_lfa1.
        READ TABLE lt_lfa1 INTO ls_lfa1 WITH  KEY lifnr = ls_bseg-Supplier.
        ASSIGN COMPONENT 'STCD2' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_lfa1-stcd2.
          UNASSIGN <fs_value>.
        ENDIF.
        ASSIGN COMPONENT 'NAME1' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_lfa1-name1.
          UNASSIGN <fs_value>.
        ENDIF.
        ASSIGN COMPONENT 'NAME2' OF STRUCTURE <fs_line> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          <fs_value> = ls_lfa1-name2.
          UNASSIGN <fs_value>.
        ENDIF.
      ENDIF.

      CLEAR ls_bseg.
      READ TABLE lt_bseg_buzid INTO ls_bseg WITH  KEY AccountingDocument = ls_belnr-belnr
                                                           CompanyCode        = ls_belnr-bukrs
                                                           FiscalYear         = ls_belnr-gjahr.
      IF sy-subrc IS INITIAL.
        LOOP AT mt_tevita INTO ls_tevita.
          ASSIGN COMPONENT ls_tevita-fieldname OF STRUCTURE <fs_line> TO <fs_value>.
          IF <fs_value> IS ASSIGNED.
            ASSIGN COMPONENT ls_tevita-fieldname OF STRUCTURE ls_bseg TO <fs_value_dyn>.
            IF <fs_value_dyn> IS ASSIGNED.
              <fs_value> = <fs_value_dyn>.
              UNASSIGN <fs_value_dyn>.
            ENDIF.
            UNASSIGN <fs_value>.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CLEAR ls_bset.
*      LOOP AT lt_bset INTO ls_bset WHERE belnr EQ ls_belnr-belnr
*                                     AND bukrs EQ ls_belnr-bukrs
*                                     AND gjahr EQ ls_belnr-gjahr.
*        CASE ls_bset-shkzg.
*          WHEN 'H'.
*            lv_percent_h = abs( ls_bset-kbetr ).
*            IF ls_tax_voran-oran IS NOT INITIAL .
*              lv_percent_h = ( ls_tax_voran-oran * 10 ).
*              lv_percent_s = ( ls_tax_voran-oran * 10 - ls_bset-kbetr ).
*            ENDIF.
*            ASSIGN COMPONENT 'MATRAH' OF STRUCTURE <fs_line> TO <fs_value>.
*            IF <fs_value> IS ASSIGNED.
*              ADD ls_bset-hwbas TO <fs_value>.
*              UNASSIGN <fs_value>.
*            ENDIF.
*            ASSIGN COMPONENT 'HESKDV' OF STRUCTURE <fs_line> TO <fs_value>.
*            IF <fs_value> IS ASSIGNED.
*              IF ls_tax_voran-oran IS INITIAL .
*                ADD ls_bset-hwste TO <fs_value>.
*              ELSE.
*                lv_hwste = ( ls_bset-hwbas * ls_tax_voran-oran ) / 100.
*                lv_hwste = lv_hwste + ( -1 * ( ( ls_bset-hwbas * ls_tax_voran-oran ) / 100 - lv_hwste ) ).
*                ADD lv_hwste TO <fs_value>.
*              ENDIF.
*              UNASSIGN <fs_value>.
*            ENDIF.
*            IF ls_tax_voran-oran IS NOT INITIAL .
*              ASSIGN COMPONENT 'VERGI' OF STRUCTURE <fs_line> TO <fs_value>.
*              IF <fs_value> IS ASSIGNED.
*                lv_hwste = ( ( ls_bset-hwbas * ls_tax_voran-oran ) / 100 - ls_bset-hwste ).
*                ADD lv_hwste TO <fs_value>.
*                UNASSIGN <fs_value>.
*              ENDIF.
*            ENDIF.
*          WHEN 'S'.
*            lv_percent_s = abs( ls_bset-kbetr ).
*            ASSIGN COMPONENT 'VERGI' OF STRUCTURE <fs_line> TO <fs_value>.
*            IF <fs_value> IS ASSIGNED.
*              ADD ls_bset-hwste TO <fs_value>.
*              UNASSIGN <fs_value>.
*            ENDIF.
*        ENDCASE.
*      ENDLOOP.

      LOOP AT lt_bset INTO ls_bset
           WHERE belnr EQ ls_belnr-belnr
             AND bukrs EQ ls_belnr-bukrs
             AND gjahr EQ ls_belnr-gjahr.

        CASE ls_bset-shkzg.

          WHEN 'H'. "Toplam KDV satırı

            "MATRAH
            ASSIGN COMPONENT 'MATRAH' OF STRUCTURE <fs_line> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
*              ADD ls_bset-hwbas TO <fs_value>.
              <fs_value> = ls_bset-hwbas.
              UNASSIGN <fs_value>.
            ENDIF.

            "HESAPLANAN KDV
            ASSIGN COMPONENT 'HESKDV' OF STRUCTURE <fs_line> TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
*              ADD ls_bset-hwste TO <fs_value>.
              <fs_value> = ( ls_tax_voran-oran * ls_bset-hwbas ) / 100.
              LV_HESKDV =  ( ls_tax_voran-oran * ls_bset-hwbas ) / 100.
              UNASSIGN <fs_value>.
            ENDIF.


*          WHEN 'S'. "Tevkifat KDV satırı

            "VERGI (tevkifat tutarı)
*            ASSIGN COMPONENT 'VERGI' OF STRUCTURE <fs_line> TO <fs_value>.
*            IF <fs_value> IS ASSIGNED.
*              ADD ls_bset-hwste TO <fs_value>.
*              UNASSIGN <fs_value>.
*            ENDIF.

        ENDCASE.

      ENDLOOP.


      ASSIGN COMPONENT 'KBETR' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
*        <fs_value> = lv_percent_h / 10.
        <fs_value> = ls_tax_voran-oran.
        UNASSIGN <fs_value>.
      ENDIF.

      ASSIGN COMPONENT 'MWSKZ' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        <fs_value> = ls_belnr-mwskz.
        UNASSIGN <fs_value>.
      ENDIF.

      CLEAR lv_percent_dec.
      ASSIGN COMPONENT 'TEVKIFATO' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
*        TRY.
*            lv_percent_dec = ( lv_percent_s / lv_percent_h ) * 10.
*          CATCH cx_sy_zerodivide.
*        ENDTRY.
*        lv_percent_h = lv_percent_dec.
*        <fs_value> = lv_percent_h.
*        SHIFT <fs_value> LEFT DELETING LEADING space.
*        SHIFT <fs_value> LEFT DELETING LEADING '0'.
*        <fs_value> = <fs_value> && '/10'.
        lv_percent_h =  ls_tax_voran-tevkifat.
        <fs_value> = |{ ls_tax_voran-tevkifat }/10|.

        UNASSIGN <fs_value>.
      ENDIF.

      ASSIGN COMPONENT 'VERGI' OF STRUCTURE <fs_line> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
*        ADD ls_bset-hwste TO <fs_value>.
        <fs_value> = ( lv_heskdv * lv_percent_h ) / 10.
        UNASSIGN <fs_value>.
        CLEAR : lv_heskdv, lv_percent_h.
      ENDIF.

      APPEND <fs_line> TO <fs_out_tev>.
    ENDLOOP.



    et_result = CORRESPONDING #( <fs_out_tev> ).


  ENDMETHOD.
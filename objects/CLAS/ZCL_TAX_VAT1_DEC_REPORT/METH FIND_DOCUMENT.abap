  METHOD find_document .

    FIELD-SYMBOLS <fs_bkpf> TYPE mty_bkpf.

*    DATA lt_bkpf_rmrp TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY awref_rev gjahr_rev.
    DATA lt_bkpf_rmrp TYPE  TABLE OF mty_bkpf.
    DATA lt_bkpf_vbrk TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY awref_rev.
    DATA lt_bkpf_rev  TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY bukrs stblg stjah.
    DATA ls_bkpf_rev_cont TYPE mty_bkpf_rev_cont.
    DATA lt_bkpf_rev_cont TYPE SORTED TABLE OF mty_bkpf_rev_cont WITH UNIQUE KEY bukrs belnr gjahr.
    DATA ls_rbkp TYPE mty_rbkp.
*    DATA lt_rbkp TYPE SORTED TABLE OF mty_rbkp WITH UNIQUE KEY belnr gjahr.
    DATA lt_rbkp TYPE  TABLE OF mty_rbkp .
    DATA ls_vbrk TYPE mty_vbrk.
    DATA lt_vbrk TYPE SORTED TABLE OF mty_vbrk WITH UNIQUE KEY vbeln.

*    SELECT i_journalentry~CompanyCode AS bukrs,
*           i_journalentry~AccountingDocument AS belnr,
*           i_journalentry~FiscalYear AS gjahr,
*           i_journalentry~AccountingDocumentType AS blart,
*           i_journalentry~PostingDate AS budat,
*           i_journalentry~FiscalPeriod AS monat,
*           i_journalentry~ReferenceDocumentType AS awtyp,
*           i_journalentry~ReversalReferenceDocument AS awref_rev,
*           i_journalentry~ReversalReferenceDocumentCntxt AS aworg_rev,
*           i_journalentry~ReverseDocument AS stblg,
*           i_journalentry~ReverseDocumentFiscalYear AS stjah,
*           i_journalentry~DocumentReferenceID AS xblnr,
*           i_journalentry~DocumentDate AS bldat
*           FROM i_journalentry
*           WHERE i_journalentry~CompanyCode EQ @p_bukrs
*             AND i_journalentry~FiscalYear EQ @p_gjahr
*             AND i_journalentry~FiscalPeriod IN @mr_monat
*             AND i_journalentry~IsReversed = @space
*             AND i_journalentry~IsReversal = @space
*            INTO TABLE @et_bkpf.
*    IF sy-subrc IS NOT INITIAL.
*      RETURN.
*    ENDIF.

*    LOOP AT et_bkpf ASSIGNING <fs_bkpf> WHERE awtyp EQ 'RMRP'.
*      CASE strlen( <fs_bkpf>-aworg_rev ).
*        WHEN 4.
*          <fs_bkpf>-gjahr_rev = <fs_bkpf>-aworg_rev.
*      ENDCASE.
*    ENDLOOP.
*
*    "elemination logic. - 1
*    INSERT LINES OF et_bkpf INTO TABLE lt_bkpf_rmrp.
*    DELETE lt_bkpf_rmrp WHERE awtyp     NE 'RMRP' OR
*                              awref_rev EQ space.
*
*    IF lines( lt_bkpf_rmrp ) GT 0.
*      SELECT i_supplierinvoiceapi01~SupplierInvoice AS belnr ,
*             i_supplierinvoiceapi01~FiscalYear AS gjahr ,
*             i_supplierinvoiceapi01~PostingDate AS budat
*             FROM i_supplierinvoiceapi01
*             FOR ALL ENTRIES IN @lt_bkpf_rmrp
*             WHERE i_supplierinvoiceapi01~SupplierInvoice EQ @lt_bkpf_rmrp-awref_rev
*               AND i_supplierinvoiceapi01~FiscalYear EQ @lt_bkpf_rmrp-gjahr_rev
*              INTO TABLE @lt_rbkp.
*
*
*      LOOP AT lt_rbkp INTO ls_rbkp.
*        DELETE et_bkpf WHERE awref_rev  EQ ls_rbkp-belnr
*                         AND gjahr_rev  EQ ls_rbkp-gjahr
*                         AND budat+4(2) EQ ls_rbkp-budat+4(2).
*      ENDLOOP.
*    ENDIF.
*
*    CLEAR lt_bkpf_rmrp.
*    CLEAR lt_rbkp.
*
*    "elemination logic - 2
*    INSERT LINES OF et_bkpf INTO TABLE lt_bkpf_vbrk.
*    DELETE lt_bkpf_vbrk WHERE awtyp     NE 'VBRK' OR
*                              awref_rev EQ space.
*
*    IF lines( lt_bkpf_vbrk ) GT 0.
*      SELECT i_billingdocumentbasic~BillingDocument AS vbeln ,
*             i_billingdocumentbasic~BillingDocumentDate AS fkdat
*             FROM i_billingdocumentbasic
*             FOR ALL ENTRIES IN @lt_bkpf_vbrk
*             WHERE BillingDocument EQ @lt_bkpf_vbrk-awref_rev
*             INTO TABLE @lt_vbrk.
*
*      LOOP AT lt_vbrk INTO ls_vbrk.
*        DELETE et_bkpf WHERE awref_rev  EQ ls_vbrk-vbeln
*                         AND budat+4(2) EQ ls_vbrk-fkdat+4(2).
*      ENDLOOP.
*    ENDIF.
*
*    CLEAR lt_vbrk.
*    CLEAR lt_bkpf_vbrk.
*
*    "elemination logic - 3
*    INSERT LINES OF et_bkpf INTO TABLE lt_bkpf_rev.
*    DELETE lt_bkpf_rev WHERE ( awtyp     EQ 'VBRK' OR
*                               awtyp     EQ 'RMRP' ) AND ( stblg EQ space ).
*
*    IF lines( lt_bkpf_rev ) GT 0.
*      SELECT CompanyCode AS bukrs ,
*             AccountingDocument AS belnr ,
*             FiscalYear  AS gjahr ,
*             PostingDate AS budat
*             FROM i_journalentry
*             FOR ALL ENTRIES IN @lt_bkpf_rev
*             WHERE CompanyCode EQ @lt_bkpf_rev-bukrs
*               AND AccountingDocument EQ @lt_bkpf_rev-stblg
*               AND FiscalYear EQ @lt_bkpf_rev-stjah
*               INTO TABLE @lt_bkpf_rev_cont.
*
*      LOOP AT lt_bkpf_rev_cont INTO ls_bkpf_rev_cont.
*        DELETE et_bkpf WHERE bukrs      EQ ls_bkpf_rev_cont-bukrs
*                         AND stblg      EQ ls_bkpf_rev_cont-belnr
*                         AND stjah      EQ ls_bkpf_rev_cont-gjahr
*                         AND budat+4(2) EQ ls_bkpf_rev_cont-budat+4(2).
*      ENDLOOP.
*    ENDIF.

    IF is_read_tab-bset EQ abap_true.
*      IF lines( et_bkpf ) GT 0.



*        SELECT
*            bset~companycode         AS bukrs,
*            bset~Accountingdocument  AS belnr,
*            bset~fiscalyear          AS gjahr,
*            bset~taxitem             AS buzei,
*            bset~taxcode             AS mwskz,
*            bset~debitcreditcode     AS shkzg,
*            bset~TaxBaseAmountInCoCodeCrcy AS hwbas,
*            bset~TaxAmountInCoCodeCrcy     AS hwste,
*            bset~TransactionTypeDetermination AS ktosl,
*            taxratio~conditionrateratio AS kbetr ,
*            taxratio~vatconditiontype AS kschl,
*            docitem~GLAccount AS hkont
*          FROM i_operationalAcctgDocTaxItem AS bset
*
*          INNER JOIN i_companycode AS t001
*          ON t001~companycode = bset~companycode
*
*          LEFT JOIN i_taxcoderate AS taxratio
*          ON  taxratio~taxcode = bset~taxcode
*          AND  taxratio~AccountKeyForGLAccount = bset~TransactionTypeDetermination
*          AND taxratio~Country = t001~Country
*          AND taxratio~cndnrecordvalidityenddate = '99991231'
*
*
*          LEFT JOIN i_operationalacctgdocitem AS docitem ON
*           docitem~CompanyCode        = bset~companycode AND
*           docitem~AccountingDocument = bset~Accountingdocument AND
*           docitem~fiscalyear         = bset~fiscalyear AND
*           docitem~AccountingDocumentItem = bset~TaxItem
*
*          FOR ALL ENTRIES IN @et_bkpf
*          WHERE bset~companycode        = @et_bkpf-bukrs
*            AND bset~Accountingdocument = @et_bkpf-belnr
*            AND bset~fiscalyear         = @et_bkpf-gjahr
*            AND bset~taxcode           IN @ir_mwskz
*        INTO TABLE @et_bset.




      SELECT
      j~taxcode AS mwskz , r~conditionrateratio AS kbetr ,r~vatconditiontype AS kschl,j~accountingdocumenttype AS blart, j~glaccount AS hkont,
        SUM( CASE WHEN ( j~transactiontypedetermination = 'VST' OR j~transactiontypedetermination = 'MWS' "OR j~transactiontypedetermination = 'ESE'
         )  THEN j~amountincompanycodecurrency ELSE 0 END ) AS hwste,
        SUM( CASE WHEN ( j~transactiontypedetermination <> 'VST' AND
                         j~transactiontypedetermination <> 'MWS' AND
                         j~transactiontypedetermination <> 'ZTA' ) THEN j~amountincompanycodecurrency ELSE 0 END ) AS hwbas
        FROM i_journalentryitem AS j
        LEFT OUTER JOIN i_taxcoderate AS r
*        on r~country = j~CountryChartOfAccounts
        ON r~cndnrecordvaliditystartdate <= j~documentdate
        AND r~cndnrecordvalidityenddate >= j~documentdate
        AND r~taxcode = j~taxcode
        AND ( r~accountkeyforglaccount = 'VST' OR r~accountkeyforglaccount = 'MWS' )
      WHERE j~ledger = '0L'
         AND j~companycode = @p_bukrs
         AND j~fiscalyear = @p_gjahr
         AND j~fiscalperiod = @p_monat
*         AND j~isreversal = ''
*         AND j~isreversed = ''
        AND ( j~financialaccounttype = 'S' OR j~financialaccounttype = 'A' )
         AND j~taxcode <> ''
         GROUP BY j~taxcode, r~conditionrateratio,r~vatconditiontype, j~accountingdocumenttype,j~glaccount
      ORDER BY j~taxcode
      INTO CORRESPONDING FIELDS OF TABLE @et_bset   .






      "yavuz test



*      ENDIF.





    ENDIF.

    IF is_read_tab-bseg EQ abap_true.

      IF lines( et_bset ) GT 0.
*        SELECT *
*               INTO TABLE et_bseg
*               FROM bseg
*               FOR ALL ENTRIES IN et_bset
*               WHERE bseg~bukrs EQ et_bset-bukrs
*                 AND bseg~belnr EQ et_bset-belnr
*                 AND bseg~gjahr EQ et_bset-gjahr.

*        SELECT DISTINCT CompanyCode AS bukrs,
*               AccountingDocument AS belnr,
*               fiscalyear AS gjahr ,
*               FinancialAccountType AS koart ,
*               supplier AS lifnr ,
*               AccountingDocumentItemType AS buzid,
*               TaxCode AS mwskz,
*               GLAccount AS hkont,
*               Reference3IDByBusinessPartner AS xref3
*               FROM i_operationalacctgdocitem AS bseg
*               FOR ALL ENTRIES IN @et_bset
*               WHERE bseg~CompanyCode EQ @et_bset-bukrs
*                 AND bseg~AccountingDocument EQ @et_bset-belnr
*                 AND bseg~fiscalyear EQ @et_bset-gjahr
*                  INTO TABLE @et_bseg.

      ELSEIF lines( et_bkpf ) GT 0.
*        SELECT *
*               INTO TABLE et_bseg
*               FROM bseg
*               FOR ALL ENTRIES IN et_bkpf
*               WHERE bseg~bukrs EQ et_bkpf-bukrs
*                 AND bseg~belnr EQ et_bkpf-belnr
*                 AND bseg~gjahr EQ et_bkpf-gjahr.

*        SELECT DISTINCT CompanyCode AS bukrs,
*               AccountingDocument AS belnr,
*               fiscalyear AS gjahr ,
*               FinancialAccountType AS koart ,
*               supplier AS lifnr ,
*               AccountingDocumentItemType AS buzid,
*               TaxCode AS mwskz,
*               GLAccount AS hkont,
*               Reference3IDByBusinessPartner AS xref3
*               FROM i_operationalacctgdocitem AS bseg
*               FOR ALL ENTRIES IN @et_bkpf
*               WHERE bseg~CompanyCode EQ @et_bkpf-bukrs
*                 AND bseg~AccountingDocument EQ @et_bkpf-belnr
*                 AND bseg~fiscalyear EQ @et_bkpf-gjahr
*                  INTO TABLE @et_bseg.

      ENDIF.

    ENDIF.

  ENDMETHOD.
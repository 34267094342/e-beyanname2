  METHOD find_document.

    FIELD-SYMBOLS <fs_bkpf> TYPE mty_bkpf.

*    DATA lt_bkpf_rmrp TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY awref_rev gjahr_rev.
    DATA lt_bkpf_rmrp TYPE TABLE OF mty_bkpf.
*    DATA lt_bkpf_vbrk TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY awref_rev.
    DATA lt_bkpf_vbrk TYPE  TABLE OF mty_bkpf .
    DATA lt_bkpf_rev  TYPE TABLE OF mty_bkpf .
*    DATA lt_bkpf_rev  TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY bukrs stblg stjah.
    DATA ls_bkpf_rev_cont TYPE mty_bkpf_rev_cont.
    DATA lt_bkpf_rev_cont TYPE  TABLE OF mty_bkpf_rev_cont ."WITH UNIQUE KEY bukrs belnr gjahr.
    DATA ls_rbkp TYPE mty_rbkp.
    DATA lt_rbkp TYPE  TABLE OF mty_rbkp ."WITH UNIQUE KEY belnr gjahr.
    DATA ls_vbrk TYPE mty_vbrk.
    DATA lt_vbrk TYPE  TABLE OF mty_vbrk ."WITH UNIQUE KEY vbeln.


    SELECT j~CompanyCode                    AS bukrs,
           j~AccountingDocument             AS belnr,
           j~FiscalYear                     AS gjahr,
           j~AccountingDocumentType         AS blart,
           j~PostingDate                    AS budat,
           j~FiscalPeriod                   AS monat,
           j~ReferenceDocumentType          AS awtyp,
           j~ReversalReferenceDocument      AS awref_rev,
           j~ReversalReferenceDocumentCntxt AS aworg_rev,
           j~ReverseDocument                AS stblg,
           j~ReverseDocumentFiscalYear      AS stjah,
           j~DocumentReferenceID            AS xblnr,
           j~DocumentDate                   AS bldat
           FROM i_journalentry AS j
           WHERE j~CompanyCode  EQ @p_bukrs
             AND j~FiscalYear   EQ @p_gjahr
             AND j~FiscalPeriod IN @mr_monat
             AND j~IsReversal   EQ ''
             AND j~IsReversed   EQ ''
             INTO TABLE @et_bkpf.

    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

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
*             i_supplierinvoiceapi01~FiscalYear      AS gjahr ,
*             i_supplierinvoiceapi01~PostingDate     AS budat
*             FROM i_supplierinvoiceapi01
*             INNER JOIN @lt_bkpf_rmrp AS rmrp
*             ON i_supplierinvoiceapi01~SupplierInvoice EQ rmrp~awref_rev
*               AND i_supplierinvoiceapi01~FiscalYear      EQ rmrp~gjahr_rev
*            INTO TABLE @lt_rbkp.
*
*      LOOP AT lt_rbkp INTO ls_rbkp.
*        DELETE et_bkpf WHERE awref_rev  EQ ls_rbkp-belnr
*                         AND gjahr_rev  EQ ls_rbkp-gjahr
*                         AND budat+4(2) EQ ls_rbkp-budat+4(2).
*      ENDLOOP.
*    ENDIF.

*    CLEAR lt_bkpf_rmrp.
*    CLEAR lt_rbkp.
*
*    "elemination logic - 2
*    INSERT LINES OF et_bkpf INTO TABLE lt_bkpf_vbrk.
*    DELETE lt_bkpf_vbrk WHERE awtyp     NE 'VBRK' OR
*                              awref_rev EQ space.

*    IF lines( lt_bkpf_vbrk ) GT 0.
*      SELECT i_billingdocumentbasic~BillingDocument     AS vbeln,
*             i_billingdocumentbasic~BillingDocumentDate AS fkdat
*             FROM i_billingdocumentbasic
*            INNER JOIN @lt_bkpf_vbrk AS vbrk
*             ON BillingDocument EQ vbrk~awref_rev
*             INTO TABLE @lt_vbrk.
*
*      LOOP AT lt_vbrk INTO ls_vbrk.
*        DELETE et_bkpf WHERE awref_rev  EQ ls_vbrk-vbeln
*                         AND budat+4(2) EQ ls_vbrk-fkdat+4(2).
*      ENDLOOP.
*    ENDIF.

*    CLEAR lt_vbrk.
*    CLEAR lt_bkpf_vbrk.

    "elemination logic - 3
*    INSERT LINES OF et_bkpf INTO TABLE lt_bkpf_rev.
*    DELETE lt_bkpf_rev WHERE ( awtyp     EQ 'VBRK' OR
*                               awtyp     EQ 'RMRP' ) AND ( stblg EQ space ).

*    IF lines( lt_bkpf_rev ) GT 0.
*      SELECT CompanyCode        AS bukrs ,
*             AccountingDocument AS belnr ,
*             FiscalYear         AS gjahr ,
*             PostingDate        AS budat
*             FROM i_journalentry
*             INNER JOIN @lt_bkpf_rev AS rev
*             ON CompanyCode        EQ rev~bukrs
*               AND AccountingDocument EQ rev~stblg
*               AND FiscalYear         EQ rev~stjah
*             INTO TABLE @lt_bkpf_rev_cont.
*
*      LOOP AT lt_bkpf_rev_cont INTO ls_bkpf_rev_cont.
*        DELETE et_bkpf WHERE bukrs      EQ ls_bkpf_rev_cont-bukrs
*                         AND stblg      EQ ls_bkpf_rev_cont-belnr
*                         AND stjah      EQ ls_bkpf_rev_cont-gjahr
*                         AND budat+4(2) EQ ls_bkpf_rev_cont-budat+4(2).
*      ENDLOOP.
*    ENDIF.

    IF is_read_tab-bset EQ abap_true.
      IF lines( et_bkpf ) GT 0.
*        SELECT
*            bset~companycode         AS bukrs,
*            bset~Accountingdocument  AS belnr,
*            bset~fiscalyear          AS gjahr,
*            bset~taxitem             AS buzei,
*            bset~taxcode             AS mwskz,
*            bset~debitcreditcode     AS shkzg,
*            bset~TaxBaseAmountInCoCodeCrcy AS hwbas,
*            bset~TaxAmountInCoCodeCrcy     AS hwste,
*            taxratio~conditionrateratio AS kbetr ,
*            taxratio~vatconditiontype AS kschl,
*            docitem~GLAccount AS hkont,
*            bset~TransactionTypeDetermination AS ktosl
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
*                    LEFT JOIN i_operationalacctgdocitem AS docitem ON
*           docitem~CompanyCode        = bset~companycode AND
*           docitem~AccountingDocument = bset~Accountingdocument AND
*           docitem~fiscalyear         = bset~fiscalyear AND
*           docitem~AccountingDocumentItem = bset~TaxItem
*
*               INNER JOIN @et_bkpf AS bkpf
*               ON bset~companycode EQ bkpf~bukrs
*                 AND bset~Accountingdocument EQ bkpf~belnr
*                 AND bset~fiscalyear EQ bkpf~gjahr
**                 AND bset~taxcode IN @ir_mwskz
*                INTO TABLE @et_bset.


*        SELECT
*            bset~companycode         AS bukrs,
*            bset~Accountingdocument  AS belnr,
*            bset~fiscalyear          AS gjahr,
**            bset~taxitem             AS buzei,
*            bset~taxcode             AS mwskz,
*            bset~debitcreditcode     AS shkzg,
*        SUM( CASE WHEN ( bset~transactiontypedetermination = 'VST' OR
*                 bset~transactiontypedetermination = 'MWS' )  THEN bset~amountincompanycodecurrency ELSE 0 END ) AS hwste,
*        SUM( CASE WHEN ( bset~transactiontypedetermination <> 'VST' AND
*                         bset~transactiontypedetermination <> 'MWS' AND
*                         bset~transactiontypedetermination <> 'ZTA' ) THEN bset~amountincompanycodecurrency ELSE 0 END ) AS hwbas,
*            taxratio~conditionrateratio AS kbetr ,
*            taxratio~vatconditiontype AS kschl,
*            bset~GLAccount AS hkont,
*            bset~TransactionTypeDetermination AS ktosl
*          FROM i_journalentryitem AS bset
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
**                    LEFT JOIN i_journalentryitem AS docitem ON
**           docitem~CompanyCode        = bset~companycode AND
**           docitem~AccountingDocument = bset~Accountingdocument AND
**           docitem~fiscalyear         = bset~fiscalyear
**           docitem~AccountingDocumentItem = bset~TaxItem
*
*               INNER JOIN @et_bkpf AS bkpf
*               ON bset~companycode EQ bkpf~bukrs
*                 AND bset~Accountingdocument EQ bkpf~belnr
*                 AND bset~fiscalyear EQ bkpf~gjahr
**                 AND bset~taxcode IN @ir_mwskz
*
*                WHERE bset~taxcode IN @ir_mwskz
*                         GROUP BY bset~companycode,bset~fiscalyear,bset~accountingdocument,bset~taxcode,   taxratio~conditionrateratio
*                         ,taxratio~vatconditiontype ,bset~GLAccount,bset~TransactionTypeDetermination, bset~debitcreditcode
*
**      ORDER BY j~taxcode
*                INTO CORRESPONDING FIELDS OF TABLE @et_bset.



        SELECT bset~companycode         AS bukrs,
               bset~accountingdocument  AS belnr,
               bset~fiscalyear          AS gjahr,
               bset~taxitem             AS buzei,
               bset~taxcode             AS mwskz,
               bset~debitcreditcode     AS shkzg,
               bset~taxbaseamountincocodecrcy AS hwbas,
               bset~taxamountincocodecrcy     AS hwste,
               taxratio~conditionrateratio AS kbetr ,
               taxratio~vatconditiontype AS kschl
*                              bset~glaccount as hkont,
*               bset~ktosl
          FROM i_operationalacctgdoctaxitem AS bset INNER JOIN i_companycode AS t001 ON t001~companycode = bset~companycode
                                                    INNER JOIN @et_bkpf AS bkpf ON bset~companycode        = bkpf~bukrs
                                                                               AND bset~accountingdocument = bkpf~belnr
                                                                               AND bset~fiscalyear         = bkpf~gjahr
                          LEFT JOIN i_taxcoderate AS taxratio
                          ON  taxratio~taxcode = bset~taxcode
                          AND  taxratio~accountkeyforglaccount = bset~transactiontypedetermination
                          AND taxratio~country = t001~country
                          AND  taxratio~cndnrecordvaliditystartdate <= bkpf~bldat
                          AND taxratio~cndnrecordvalidityenddate >= bkpf~bldat
        WHERE bset~taxcode IN @lr_mwskz
        INTO TABLE @et_bset.




      ENDIF.
    ENDIF.

    IF is_read_tab-bseg EQ abap_true.

      IF lines( et_bset ) GT 0.
        SELECT *
             FROM i_journalentryitem AS j
             INNER JOIN @et_bset AS bset
             ON j~CompanyCode        EQ bset~bukrs
               AND j~AccountingDocument EQ bset~belnr
               AND j~FiscalYear         EQ bset~gjahr
              INTO CORRESPONDING FIELDS OF TABLE @et_bseg.
*      ELSEIF lines( et_bkpf ) GT 0.
*        SELECT *
*               FROM i_journalentryitem AS j
*               INNER JOIN @et_bkpf AS bkpf
*               ON j~CompanyCode        EQ bkpf~bukrs
*                 AND j~AccountingDocument EQ bkpf~belnr
*                 AND j~FiscalYear         EQ bkpf~gjahr
*                INTO CORRESPONDING FIELDS OF TABLE @et_bseg.
      ENDIF.

    ENDIF.

  ENDMETHOD.
  METHOD get_item_data.

    DATA lr_fiscyearper TYPE RANGE OF fis_jahrper_conv.
    DATA lt_reversed    TYPE mtty_data.
    DATA lt_reversing   TYPE mtty_data.
    DATA lt_lifnr       TYPE mtty_data.
    DATA lt_data        TYPE mtty_data.

*
    me->fill_period( EXPORTING ir_monat       = mr_monat
                     IMPORTING er_fiscyearper = lr_fiscyearper ).
*
*


    CLEAR et_mg.
    CLEAR et_data.
    CLEAR et_lfb1.
*
    SELECT ztax_t_mg~bukrs,
           ztax_t_mg~kiril1,
           ztax_t_mk1~acklm AS acklm1,
           ztax_t_mg~kiril2,
           ztax_t_mk2~acklm AS acklm2,
           ztax_t_mg~hkont,
           i_glaccounttext~glaccountlongname AS txt50,"skat~txt50,
           ztax_t_mg~mindk
*           t059t~mtext
          FROM i_companycode"t001
          INNER JOIN ztax_t_mg  ON ztax_t_mg~bukrs   EQ i_companycode~companycode
          INNER JOIN ztax_t_mk1 ON ztax_t_mk1~kiril1 EQ ztax_t_mg~kiril1
          INNER JOIN ztax_t_mk2 ON ztax_t_mk2~kiril2 EQ ztax_t_mg~kiril2
          LEFT OUTER JOIN i_glaccounttext  ON i_glaccounttext~language        EQ @sy-langu
                                          AND i_glaccounttext~chartofaccounts EQ i_companycode~chartofaccounts
                                          AND i_glaccounttext~glaccount       EQ ztax_t_mg~hkont
*          LEFT OUTER JOIN t059t  ON t059t~spras EQ @sy-langu
*                                AND t059t~mindk EQ ztax_t_mg~mindk
          WHERE ztax_t_mg~bukrs EQ @p_bukrs
           INTO TABLE @et_mg.
*

    SELECT i_journalentryitem~CompanyCode AS bukrs ,
           i_journalentryitem~FiscalYear AS gjahr ,
           i_journalentryitem~AccountingDocument AS belnr ,
           i_journalentryitem~LedgerGLLineItem AS docln ,
           i_journalentryitem~LedgerFiscalYear AS ryear ,
           i_journalentryitem~FiscalYearPeriod AS fiscyearper ,
           i_journalentryitem~AmountInCompanyCodeCurrency AS hsl ,
           i_journalentryitem~AmountInTransactionCurrency AS wsl ,
           i_journalentryitem~DebitCreditCode AS drcrk ,
           i_journalentryitem~ReversalReferenceDocument AS awref_rev ,
           i_journalentryitem~ReversalReferenceDocumentCntxt AS aworg_rev ,
           i_journalentryitem~ReferenceDocumentType AS awtyp ,
           i_journalentryitem~ReferenceDocument AS awref ,
           i_journalentryitem~ReferenceDocumentContext AS aworg ,
           i_journalentryitem~IsReversal AS xreversing ,
           i_journalentryitem~IsReversed AS xreversed ,
           i_journalentryitem~Supplier AS lifnr ,
           i_journalentryitem~GLAccount AS racct ,
           i_glaccounttext~GLAccountLongName AS txt50 ,
           i_journalentryitem~DocumentItemText AS sgtxt ,
           i_businesspartner~FirstName AS name1 ,
           i_businesspartner~LastName  AS name2 ,
           i_businesspartner~OrganizationBPName1 AS name_org1 ,
           i_businesspartner~OrganizationBPName2 AS name_org2 ,
           i_journalentryitem~TransactionCurrency AS rwcur ,
           i_journalentryitem~AssignmentReference AS zuonr ,
           i_companycode~CompanyCodeName AS butxt ,
           i_journalentry~DocumentReferenceID AS xblnr ,
           i_journalentryitem~PostingDate AS budat ,
           i_supplier~StreetName AS stras ,
*           I_SUPPLIER~ as mcod3
           i_supplier~Region AS regio ,
           i_supplier~Country AS land1 ,
           i_supplier~TaxNumber2 AS stcd2 ,
           i_journalentryitem~FinancialAccountType AS koart,
           "
              wh~withholdingtaxtype AS witht,
              wh~withholdingtaxcode AS wt_withcd
           FROM i_journalentryitem
           "
           INNER JOIN i_companycode
           ON i_companycode~companycode EQ i_journalentryitem~companycode
           "
           INNER JOIN i_journalentry
           ON i_journalentry~companycode  EQ i_journalentryitem~companycode
           AND i_journalentry~accountingdocument EQ i_journalentryitem~accountingdocument
           AND i_journalentry~fiscalyear EQ i_journalentryitem~fiscalyear

           INNER JOIN i_withholdingtaxitem AS wh
           ON wh~companycode EQ  i_journalentryitem~companycode
           AND wh~accountingdocument EQ i_journalentryitem~accountingdocument
           AND wh~fiscalyear EQ i_journalentryitem~fiscalyear
           AND wh~accountingdocumentitem EQ i_journalentryitem~accountingdocumentitem
           LEFT OUTER JOIN i_glaccounttext
            ON i_glaccounttext~Language        EQ @sy-langu
           AND i_glaccounttext~ChartOfAccounts EQ i_journalentryitem~ChartOfAccounts
           AND i_glaccounttext~GLAccount       EQ i_journalentryitem~GLAccount
           "
           LEFT OUTER JOIN  i_businesspartner
           ON i_businesspartner~businesspartner        EQ i_journalentryitem~supplier
           "
           LEFT OUTER JOIN  i_supplier
           ON  i_supplier~supplier           EQ i_journalentryitem~supplier
           "
           WHERE i_journalentryitem~fiscalyear       EQ @p_gjahr
             AND i_journalentryitem~companycode      EQ @p_bukrs
             AND i_journalentryitem~FiscalYearPeriod IN @lr_fiscyearper
             AND ( ( i_journalentryitem~IsReversal   IS INITIAL AND i_journalentryitem~DebitCreditCode EQ 'H' ) OR ( i_journalentryitem~IsReversal EQ @abap_true AND i_journalentryitem~DebitCreditCode  EQ 'S' ) )
             AND i_journalentryitem~referencedocumenttype       NE 'RMRP'
             AND i_journalentryitem~SourceLedger       EQ '0L'
             AND EXISTS ( "
                          SELECT *
                           FROM i_journalentryitem AS account
                           "
                           INNER JOIN ztax_t_mg AS mg1
                           ON  mg1~bukrs  EQ account~companycode
                           AND mg1~hkont  EQ account~GLAccount
                           "
                           WHERE account~SourceLedger       EQ i_journalentryitem~SourceLedger
                             AND account~companycode      EQ i_journalentryitem~companycode
                             AND account~accountingdocument       EQ i_journalentryitem~accountingdocument
                             AND account~fiscalyear       EQ i_journalentryitem~fiscalyear
                             AND account~FiscalYearPeriod EQ I_JournalEntryItem~FiscalYearPeriod
                             AND ( ( account~IsReversal EQ @space AND account~DebitCreditCode EQ 'H' ) OR ( account~DebitCreditCode EQ @abap_true AND account~DebitCreditCode  EQ 'S' ) )
                             AND EXISTS ( "
                                          SELECT *
                                            FROM i_journalentryitem AS gricd
                                            "
                                            LEFT OUTER JOIN i_suppliercompany
                                            ON i_suppliercompany~companycode EQ gricd~companycode
                                            AND i_suppliercompany~supplier EQ gricd~supplier
                                            "
*                                            INNER JOIN ztax_t_mindk AS mindk
*                                             ON  mindk~bukrs  EQ gricd~companycode
*                                             AND mindk~lifnr  EQ i_suppliercompany~Supplier

                                            INNER JOIN ztax_t_mg AS mg12
                                             ON  mg12~bukrs  EQ gricd~companycode
*                                             AND mg12~mindk  EQ mindk~mindk

                                             "

                                             "
                                             WHERE gricd~SourceLedger       EQ account~SourceLedger
                                               AND gricd~CompanyCode        EQ account~CompanyCode
                                               AND gricd~AccountingDocument EQ account~AccountingDocument
                                               AND gricd~FiscalYear         EQ account~FiscalYear
                                               AND gricd~FiscalYearPeriod   EQ account~FiscalYearPeriod
                                               AND mg12~hkont               EQ account~GLAccount
                                               AND ( ( gricd~IsReversal IS INITIAL AND gricd~DebitCreditCode EQ 'H' ) OR ( gricd~IsReversal EQ @abap_true AND gricd~DebitCreditCode  EQ 'S' ) )
                                         )
                            )
                             INTO CORRESPONDING FIELDS OF TABLE @et_data.
*
*
*
    SELECT i_journalentryitem~CompanyCode AS bukrs ,
           i_journalentryitem~FiscalYear AS gjahr ,
           i_journalentryitem~AccountingDocument AS belnr ,
           i_journalentryitem~LedgerGLLineItem AS docln ,
           i_journalentryitem~LedgerFiscalYear AS ryear ,
           i_journalentryitem~FiscalYearPeriod AS fiscyearper ,
           i_journalentryitem~AmountInCompanyCodeCurrency AS hsl ,
           i_journalentryitem~AmountInTransactionCurrency AS wsl ,
           i_journalentryitem~DebitCreditCode AS drcrk ,
           i_journalentryitem~ReversalReferenceDocument AS awref_rev ,
           i_journalentryitem~ReversalReferenceDocumentCntxt AS aworg_rev ,
           i_journalentryitem~ReferenceDocumentType AS awtyp ,
           i_journalentryitem~ReferenceDocument AS awref ,
           i_journalentryitem~ReferenceDocumentContext AS aworg ,
           i_journalentryitem~IsReversal AS xreversing ,
           i_journalentryitem~IsReversed AS xreversed ,
           i_supplierinvoiceapi01~InvoicingParty AS lifnr ,
           i_journalentryitem~GLAccount AS racct ,
           i_glaccounttext~GLAccountLongName AS txt50 ,
           i_journalentryitem~DocumentItemText AS sgtxt ,
           i_businesspartner~FirstName AS name1 ,
           i_businesspartner~LastName  AS name2 ,
           i_businesspartner~OrganizationBPName1 AS name_org1 ,
           i_businesspartner~OrganizationBPName2 AS name_org2 ,
           i_journalentryitem~TransactionCurrency AS rwcur ,
           i_journalentryitem~AssignmentReference AS zuonr ,
           i_companycode~CompanyCodeName AS butxt ,
           i_journalentry~DocumentReferenceID AS xblnr ,
           i_journalentryitem~PostingDate AS budat ,
           i_supplier~StreetName AS stras ,
*           I_SUPPLIER~ as mcod3
           i_supplier~Region AS regio ,
           i_supplier~Country AS land1 ,
           i_supplier~TaxNumber2 AS stcd2 ,
           i_journalentryitem~FinancialAccountType AS koart,
           wh~withholdingtaxtype AS witht,
           wh~withholdingtaxcode AS wt_withcd
           "
           FROM i_journalentryitem
           INNER JOIN i_companycode
           ON i_companycode~CompanyCode EQ i_journalentryitem~CompanyCode
           "
            LEFT OUTER JOIN i_supplierinvoiceapi01
            ON i_supplierinvoiceapi01~SupplierInvoice EQ i_journalentryitem~ReferenceDocument
           AND i_supplierinvoiceapi01~FiscalYear      EQ i_journalentryitem~ReferenceDocumentContext
           "
           INNER JOIN i_journalentry
            ON i_journalentry~CompanyCode        EQ i_journalentryitem~CompanyCode
           AND i_journalentry~AccountingDocument EQ i_journalentryitem~AccountingDocument
           AND i_journalentry~FiscalYear         EQ i_journalentryitem~FiscalYear

                         INNER JOIN i_withholdingtaxitem AS wh
              ON wh~companycode EQ  i_journalentryitem~companycode
              AND wh~accountingdocument EQ i_journalentryitem~accountingdocument
              AND wh~fiscalyear EQ i_journalentryitem~fiscalyear
              AND wh~accountingdocumentitem EQ i_journalentryitem~accountingdocumentitem
           "
           LEFT OUTER JOIN i_glaccounttext
            ON i_glaccounttext~Language        EQ @sy-langu
           AND i_glaccounttext~ChartOfAccounts EQ i_journalentryitem~ChartOfAccounts
           AND i_glaccounttext~GLAccount       EQ i_journalentryitem~GLAccount
           "
           LEFT OUTER JOIN i_businesspartner
           ON i_businesspartner~BusinessPartner EQ i_journalentryitem~Supplier
           "
           LEFT OUTER JOIN i_supplier
           ON i_supplier~Supplier           EQ i_supplierinvoiceapi01~InvoicingParty
           "
           WHERE i_journalentryitem~FiscalYear       EQ @p_gjahr
             AND i_journalentryitem~CompanyCode      EQ @p_bukrs
             AND i_journalentryitem~FiscalYearPeriod IN @lr_fiscyearper
             AND ( ( i_journalentryitem~IsReversal   IS INITIAL AND i_journalentryitem~DebitCreditCode EQ 'H' ) OR ( i_journalentryitem~IsReversal EQ @abap_true AND i_journalentryitem~DebitCreditCode  EQ 'S' ) )
             AND i_journalentryitem~ReferenceDocumentType EQ 'RMRP'
             AND i_journalentryitem~SourceLedger          EQ '0L'
             AND EXISTS ( "
                          SELECT *
                           FROM i_journalentryitem AS account
                           "
                           INNER JOIN ztax_t_mg AS mg1
                           ON  mg1~bukrs  EQ account~CompanyCode
                           AND mg1~hkont  EQ account~GLAccount
                           "
                           WHERE account~SourceLedger       EQ i_journalentryitem~SourceLedger
                             AND account~CompanyCode        EQ i_journalentryitem~CompanyCode
                             AND account~AccountingDocument EQ i_journalentryitem~AccountingDocument
                             AND account~FiscalYear         EQ i_journalentryitem~FiscalYear
                             AND account~FiscalYearPeriod   EQ i_journalentryitem~FiscalYearPeriod
                             AND ( ( account~IsReversal IS INITIAL AND account~DebitCreditCode EQ 'H' ) OR ( account~IsReversal EQ @abap_true AND account~DebitCreditCode  EQ 'S' ) )
                             AND EXISTS ( "
                                          SELECT *
                                            FROM i_journalentryitem AS gricd
                                            "
                                            LEFT OUTER JOIN i_supplierinvoiceapi01
                                             ON i_supplierinvoiceapi01~SupplierInvoice EQ gricd~ReferenceDocument
                                            AND i_supplierinvoiceapi01~FiscalYear      EQ gricd~ReferenceDocumentContext
                                            "
                                            LEFT OUTER JOIN i_suppliercompany
                                             ON i_suppliercompany~CompanyCode EQ i_supplierinvoiceapi01~CompanyCode
                                            AND i_suppliercompany~Supplier    EQ i_supplierinvoiceapi01~InvoicingParty
                                            "
                                           INNER JOIN ztax_t_mindk AS mindk
                                             ON  mindk~bukrs  EQ i_supplierinvoiceapi01~CompanyCode
                                             AND mindk~lifnr  EQ i_supplierinvoiceapi01~InvoicingParty

                                            INNER JOIN ztax_t_mg AS mg12
                                             ON  mg12~bukrs  EQ gricd~CompanyCode
                                             AND mg12~mindk  EQ mindk~mindk
                                             "
                                             WHERE gricd~SourceLedger       EQ account~SourceLedger
                                               AND gricd~CompanyCode        EQ account~CompanyCode
                                               AND gricd~AccountingDocument EQ account~AccountingDocument
                                               AND gricd~FiscalYear         EQ account~FiscalYear
                                               AND gricd~FiscalYearPeriod   EQ account~FiscalYearPeriod
                                               AND mg12~hkont               EQ account~GLAccount
                                               AND ( ( gricd~IsReversal IS INITIAL AND gricd~DebitCreditCode EQ 'H' ) OR ( gricd~IsReversal EQ @abap_true AND gricd~DebitCreditCode  EQ 'S' ) )
                                            )
                            )
                APPENDING TABLE @et_data.
*    .
*

    lt_reversed  = et_data.
    lt_reversing = et_data.


    DELETE lt_reversed  WHERE awref_rev EQ space AND xreversed  EQ space.
    DELETE lt_reversing WHERE awref_rev EQ space AND xreversing EQ space.

    SORT lt_reversed  BY awref_rev aworg_rev.
    SORT lt_reversing BY awref aworg.
    DELETE ADJACENT DUPLICATES FROM lt_reversed COMPARING awref_rev aworg_rev.
    DELETE ADJACENT DUPLICATES FROM lt_reversing COMPARING awref aworg.

    LOOP AT lt_reversed INTO DATA(ls_reversed).

      READ TABLE lt_reversing TRANSPORTING NO FIELDS WITH KEY awref = ls_reversed-awref_rev
                                                              aworg = ls_reversed-aworg_rev
                                                              BINARY SEARCH.
      " CHECK sy-subrc IS INITIAL.
      IF sy-subrc IS INITIAL.
        DELETE et_data WHERE awref_rev EQ ls_reversed-awref_rev
                         AND aworg_rev EQ ls_reversed-aworg_rev.

        DELETE et_data WHERE awref EQ ls_reversed-awref_rev
                         AND aworg EQ ls_reversed-aworg_rev.


      ELSE.
        " XREVERSED = X ise doğrudan BELNR ile sil
        IF ls_reversed-xreversed EQ abap_true.
          DELETE et_data WHERE bukrs EQ ls_reversed-bukrs
                           AND belnr EQ ls_reversed-belnr
                           AND gjahr EQ ls_reversed-gjahr.
        ENDIF.
      ENDIF.


    ENDLOOP.

    lt_lifnr = et_data.
    SORT lt_lifnr BY bukrs lifnr.
    DELETE ADJACENT DUPLICATES FROM lt_lifnr COMPARING bukrs lifnr.

    IF lines( lt_lifnr ) GT 0.

      SELECT a~supplier AS lifnr,
             a~companycode AS bukrs,
             b~mindk

             FROM i_suppliercompany AS a
             LEFT OUTER JOIN ztax_t_mindk AS b ON  b~bukrs = a~companycode
                                              AND b~lifnr = a~supplier
             FOR ALL ENTRIES IN @lt_lifnr
             WHERE a~supplier EQ @lt_lifnr-lifnr
               AND a~companycode EQ @lt_lifnr-bukrs
                INTO TABLE  @et_lfb1.

    ENDIF.

    SORT et_lfb1 BY bukrs lifnr.
    SORT et_mg BY bukrs hkont mindk.

    IF lines( et_data ) GT 0.

      lt_data = et_data.

      SORT lt_data BY bukrs
                      gjahr
                      belnr.

      DELETE ADJACENT DUPLICATES FROM lt_data COMPARING bukrs
                                                        gjahr
                                                        belnr.
*
      SELECT i_journalentryitem~CompanyCode AS bukrs ,
             i_journalentryitem~FiscalYear AS gjahr ,
             i_journalentryitem~AccountingDocument AS belnr ,
             i_journalentryitem~LedgerGLLineItem AS docln ,
             i_journalentryitem~LedgerFiscalYear AS ryear ,
             i_journalentryitem~FiscalYearPeriod AS fiscyearper ,
             i_journalentryitem~AmountInCompanyCodeCurrency AS hsl ,
             i_journalentryitem~AmountInTransactionCurrency AS wsl ,
             i_journalentryitem~DebitCreditCode AS drcrk ,
             i_journalentryitem~ReversalReferenceDocument AS awref_rev ,
             i_journalentryitem~ReversalReferenceDocumentCntxt AS aworg_rev ,
             i_journalentryitem~ReferenceDocumentType AS awtyp ,
             i_journalentryitem~ReferenceDocument AS awref ,
             i_journalentryitem~ReferenceDocumentContext AS aworg ,
             i_journalentryitem~IsReversal AS xreversing ,
             i_journalentryitem~IsReversed AS xreversed ,
             i_journalentryitem~Supplier AS lifnr ,
             i_journalentryitem~GLAccount AS racct ,
             i_journalentryitem~DocumentItemText AS sgtxt ,
             i_journalentryitem~TransactionCurrency AS rwcur ,
             i_journalentryitem~AssignmentReference AS zuonr ,
             i_journalentryitem~PostingDate AS budat ,
             i_journalentryitem~FinancialAccountType AS koart
               FROM i_journalentryitem
               FOR ALL ENTRIES IN @lt_data
               WHERE SourceLedger  EQ '0L'
                 AND CompanyCode   EQ @lt_data-bukrs
                 AND FiscalYear    EQ @lt_data-gjahr
                 AND AccountingDocument  EQ @lt_data-belnr
                 AND GLAccount  LIKE '191%'
                INTO TABLE @et_data_191.

    ENDIF.




  ENDMETHOD.
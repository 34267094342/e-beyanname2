  METHOD get_item_data.

    DATA lr_fiscyearper TYPE RANGE OF i_journalentryitem-fiscalyearperiod."fiscyearper.
    DATA lt_reversed    TYPE mtty_data.
    DATA lt_reversing   TYPE mtty_data.
    DATA lt_lifnr       TYPE mtty_data.
    DATA lt_data        TYPE mtty_data.

    IF p_monat IS NOT INITIAL.
      APPEND INITIAL LINE TO mr_monat ASSIGNING FIELD-SYMBOL(<fs_monat>).
      <fs_monat>-sign = 'I'.
      <fs_monat>-option = 'EQ'.
      <fs_monat>-low = p_monat.
      <fs_monat>-high = ''.
    ENDIF.

    me->fill_period( EXPORTING ir_monat       = mr_monat
                     IMPORTING er_fiscyearper = lr_fiscyearper ).

    CLEAR et_mg.
    CLEAR et_data.
    CLEAR et_lfb1.

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



    .

    SELECT i_journalentryitem~companycode AS bukrs ,
              i_journalentryitem~fiscalyear AS gjahr ,
              i_journalentryitem~accountingdocument AS belnr ,
              i_journalentryitem~ledgergllineitem AS docln ,
           i_journalentryitem~ledgerfiscalyear AS ryear ,
           i_journalentryitem~fiscalyearperiod AS fiscyearper ,
              i_journalentryitem~amountincompanycodecurrency AS hsl ,
              i_journalentryitem~amountintransactioncurrency AS wsl ,
              i_journalentryitem~debitcreditcode AS drcrk ,
           i_journalentryitem~reversalreferencedocument AS awref_rev ,
           i_journalentryitem~reversalreferencedocumentcntxt AS aworg_rev ,
              i_journalentryitem~referencedocumenttype AS awtyp ,
           i_journalentryitem~referencedocument AS awref ,
           i_journalentryitem~referencedocumentcontext AS aworg ,
           i_journalentryitem~isreversal AS xreversing ,
           i_journalentryitem~isreversed AS xreversed ,
              i_journalentryitem~supplier AS lifnr ,
              i_journalentryitem~glaccount AS racct ,
              i_glaccounttext~glaccountlongname AS txt50 ,
              i_journalentryitem~documentitemtext AS sgtxt ,
              i_businesspartner~firstname AS name1 ,
              i_businesspartner~lastname  AS name2 ,
              i_businesspartner~organizationbpname1 AS name_org1 ,
              i_businesspartner~organizationbpname2 AS name_org2 ,
              i_journalentryitem~transactioncurrency AS rwcur ,
              i_journalentryitem~assignmentreference AS zuonr ,
              i_companycode~companycodename AS butxt ,
              i_journalentry~documentreferenceid AS xblnr ,
              i_journalentryitem~postingdate AS budat ,
              i_supplier~streetname AS stras ,
*           I_SUPPLIER~ as mcod3
              i_supplier~region AS regio ,
              i_supplier~country AS land1 ,
              i_supplier~taxnumber2 AS stcd2 ,
              i_journalentryitem~financialaccounttype AS koart ,
              "
              wh~withholdingtaxtype AS witht,
              wh~withholdingtaxcode AS wt_withcd
*              wh~whldgtaxamtincocodecrcy AS taxamount,
*              wh~whldgtaxbaseamtincocodecrcy AS baseamount
              FROM i_journalentryitem
              "
              INNER JOIN i_companycode
              ON i_companycode~companycode EQ i_journalentryitem~companycode
              "
              INNER JOIN i_journalentry
               ON i_journalentry~companycode EQ i_journalentryitem~companycode
              AND i_journalentry~accountingdocument EQ i_journalentryitem~accountingdocument
              AND i_journalentry~fiscalyear EQ i_journalentryitem~fiscalyear
              "
              INNER JOIN i_withholdingtaxitem AS wh
              ON wh~companycode EQ  i_journalentryitem~companycode
              AND wh~accountingdocument EQ i_journalentryitem~accountingdocument
              AND wh~fiscalyear EQ i_journalentryitem~fiscalyear
              AND wh~accountingdocumentitem EQ i_journalentryitem~accountingdocumentitem
              LEFT OUTER JOIN i_glaccounttext
               ON i_glaccounttext~language        EQ @sy-langu
              AND i_glaccounttext~chartofaccounts EQ i_journalentryitem~chartofaccounts
              AND i_glaccounttext~glaccount       EQ i_journalentryitem~glaccount
              "
              LEFT OUTER JOIN i_businesspartner
              ON i_businesspartner~businesspartner EQ i_journalentryitem~supplier
              "
              LEFT OUTER JOIN i_supplier
              ON i_supplier~supplier            EQ i_journalentryitem~supplier
              "
              WHERE i_journalentryitem~fiscalyear       EQ @p_gjahr
                AND i_journalentryitem~companycode      EQ @p_bukrs
                AND i_journalentryitem~fiscalyearperiod IN @lr_fiscyearper
                AND ( ( i_journalentryitem~isreversal   IS INITIAL AND i_journalentryitem~debitcreditcode EQ 'H' ) OR ( i_journalentryitem~isreversal EQ @abap_true AND i_journalentryitem~debitcreditcode  EQ 'S' ) )
                AND i_journalentryitem~referencedocumenttype  NE 'RMRP'
                AND i_journalentryitem~sourceledger       EQ '0L'
                AND EXISTS ( "
                             SELECT *
                              FROM i_journalentryitem AS account
                              "
                              INNER JOIN ztax_t_mg AS mg1
                              ON  mg1~bukrs  EQ account~companycode
                              AND mg1~hkont  EQ account~glaccount
                              "
                              WHERE   account~sourceledger       EQ i_journalentryitem~sourceledger
                                AND   account~companycode        EQ i_journalentryitem~companycode
                                AND   account~accountingdocument EQ i_journalentryitem~accountingdocument
                                AND   account~fiscalyear         EQ i_journalentryitem~fiscalyear
                                AND   account~fiscalyearperiod   EQ i_journalentryitem~fiscalyearperiod
                             AND ( (  account~isreversal IS INITIAL AND account~debitcreditcode EQ 'H' ) OR ( account~isreversal EQ @abap_true AND account~debitcreditcode  EQ 'S' ) )
                                AND EXISTS ( "
                                             SELECT *
                                               FROM i_journalentryitem AS gricd
                                               INNER JOIN i_suppliercompany
                                               ON i_suppliercompany~companycode EQ gricd~companycode
                                               AND i_suppliercompany~supplier EQ gricd~supplier
                                               "
*                                               INNER JOIN ztax_t_mindk AS mindk
*                                                ON  mindk~bukrs  EQ gricd~CompanyCode
*                                                AND mindk~lifnr  EQ i_suppliercompany~Supplier

                                               INNER JOIN ztax_t_mg AS mg12
                                                ON  mg12~bukrs  EQ gricd~companycode
*                                                AND mg12~mindk  EQ mindk~mindk

                                                WHERE gricd~sourceledger       EQ account~sourceledger
                                                  AND gricd~companycode        EQ account~companycode
                                                  AND gricd~accountingdocument EQ account~accountingdocument
                                                  AND gricd~fiscalyear         EQ account~fiscalyear
                                                  AND gricd~fiscalyearperiod   EQ account~fiscalyearperiod
                                                  AND mg12~hkont               EQ account~glaccount
                                                  AND ( ( gricd~isreversal IS INITIAL AND gricd~debitcreditcode EQ 'H' ) OR ( gricd~isreversal EQ @abap_true AND gricd~debitcreditcode  EQ 'S' ) )
                                            )
                               )
                     INTO CORRESPONDING FIELDS OF TABLE @et_data.



    SELECT i_journalentryitem~companycode AS bukrs ,
           i_journalentryitem~fiscalyear AS gjahr ,
           i_journalentryitem~accountingdocument AS belnr ,
           i_journalentryitem~ledgergllineitem AS docln ,
           i_journalentryitem~ledgerfiscalyear AS ryear ,
           i_journalentryitem~fiscalyearperiod AS fiscyearper ,
           i_journalentryitem~amountincompanycodecurrency AS hsl ,
           i_journalentryitem~amountintransactioncurrency AS wsl ,
           i_journalentryitem~debitcreditcode AS drcrk ,
           i_journalentryitem~reversalreferencedocument AS awref_rev ,
           i_journalentryitem~reversalreferencedocumentcntxt AS aworg_rev ,
           i_journalentryitem~referencedocumenttype AS awtyp ,
           i_journalentryitem~referencedocument AS awref ,
           i_journalentryitem~referencedocumentcontext AS aworg ,
           i_journalentryitem~isreversal AS xreversing ,
           i_journalentryitem~isreversed AS xreversed ,
*           i_supplierinvoiceapi01~InvoicingParty AS lifnr ,
           i_journalentryitem~glaccount AS racct ,
           i_glaccounttext~glaccountlongname AS txt50 ,
           i_journalentryitem~documentitemtext AS sgtxt ,
           i_businesspartner~firstname AS name1 ,
           i_businesspartner~lastname  AS name2 ,
           i_businesspartner~organizationbpname1 AS name_org1 ,
           i_businesspartner~organizationbpname2 AS name_org2 ,
           i_journalentryitem~transactioncurrency AS rwcur ,
           i_journalentryitem~assignmentreference AS zuonr ,
           i_companycode~companycodename AS butxt ,
           i_journalentry~documentreferenceid AS xblnr ,
           i_journalentryitem~postingdate AS budat ,
           i_supplier~streetname AS stras ,
*           i_supplier~ AS mcod3
           i_supplier~region AS regio ,
           i_supplier~country AS land1 ,
           i_supplier~taxnumber2 AS stcd2 ,
           i_journalentryitem~financialaccounttype AS koart,
           "
           wh~withholdingtaxtype AS witht,
           wh~withholdingtaxcode AS wt_withcd
*           wh~whldgtaxamtincocodecrcy AS taxamount,
*           wh~whldgtaxbaseamtincocodecrcy AS baseamount
           "
           FROM i_journalentryitem
           INNER JOIN i_companycode
           ON i_companycode~companycode EQ i_journalentryitem~companycode
           "
           INNER JOIN i_supplierinvoiceapi01
            ON i_supplierinvoiceapi01~supplierinvoice EQ i_journalentryitem~referencedocument
           AND i_supplierinvoiceapi01~fiscalyear      EQ i_journalentryitem~referencedocumentcontext
           "
           INNER JOIN i_journalentry
            ON i_journalentry~companycode        EQ i_journalentryitem~companycode
           AND i_journalentry~accountingdocument EQ i_journalentryitem~accountingdocument
           AND i_journalentry~fiscalyear         EQ i_journalentryitem~fiscalyear
           "
              INNER JOIN i_withholdingtaxitem AS wh
              ON wh~companycode EQ  i_journalentryitem~companycode
              AND wh~accountingdocument EQ i_journalentryitem~accountingdocument
              AND wh~fiscalyear EQ i_journalentryitem~fiscalyear
              AND wh~accountingdocumentitem EQ i_journalentryitem~accountingdocumentitem

           LEFT OUTER JOIN i_glaccounttext
            ON i_glaccounttext~language        EQ @sy-langu
           AND i_glaccounttext~chartofaccounts EQ i_journalentryitem~chartofaccounts
           AND i_glaccounttext~glaccount       EQ i_journalentryitem~glaccount
           "
           LEFT OUTER JOIN i_businesspartner
           ON i_businesspartner~businesspartner EQ i_journalentryitem~supplier
           "
           LEFT OUTER JOIN i_supplier
           ON i_supplier~supplier           EQ i_supplierinvoiceapi01~invoicingparty
           "
           WHERE i_journalentryitem~fiscalyear       EQ @p_gjahr
             AND i_journalentryitem~companycode      EQ @p_bukrs
             AND i_journalentryitem~fiscalyearperiod IN @lr_fiscyearper
             AND ( ( i_journalentryitem~isreversal   IS INITIAL AND i_journalentryitem~debitcreditcode EQ 'H' ) OR ( i_journalentryitem~isreversal EQ @abap_true AND i_journalentryitem~debitcreditcode  EQ 'S' ) )
             AND i_journalentryitem~referencedocumenttype EQ 'RMRP'
             AND i_journalentryitem~sourceledger          EQ '0L'
             AND EXISTS ( "
                          SELECT *
                           FROM i_journalentryitem AS account
                           "
                           INNER JOIN ztax_t_mg AS mg1
                           ON  mg1~bukrs  EQ account~companycode
                           AND mg1~hkont  EQ account~glaccount
                           "
                           WHERE account~sourceledger       EQ i_journalentryitem~sourceledger
                             AND account~companycode        EQ i_journalentryitem~companycode
                             AND account~accountingdocument EQ i_journalentryitem~accountingdocument
                             AND account~fiscalyear         EQ i_journalentryitem~fiscalyear
                             AND account~fiscalyearperiod   EQ i_journalentryitem~fiscalyearperiod
                             AND ( ( account~isreversal IS INITIAL AND account~debitcreditcode EQ 'H' ) OR ( account~isreversal EQ @abap_true AND account~debitcreditcode  EQ 'S' ) )
                             AND EXISTS ( "
                                          SELECT *
                                            FROM i_journalentryitem AS gricd
                                            INNER JOIN i_supplierinvoiceapi01
                                             ON i_supplierinvoiceapi01~supplierinvoice EQ gricd~referencedocument
                                            AND i_supplierinvoiceapi01~fiscalyear      EQ gricd~referencedocumentcontext

                                            INNER JOIN i_suppliercompany
                                             ON i_suppliercompany~companycode EQ i_supplierinvoiceapi01~companycode
                                            AND i_suppliercompany~supplier    EQ i_supplierinvoiceapi01~invoicingparty

*                                           INNER JOIN ztax_t_mindk AS mindk
*                                             ON  mindk~bukrs  EQ i_supplierinvoiceapi01~CompanyCode
*                                             AND mindk~lifnr  EQ i_supplierinvoiceapi01~InvoicingParty

                                            INNER JOIN ztax_t_mg AS mg12
                                             ON  mg12~bukrs  EQ gricd~companycode
*                                             AND mg12~mindk  EQ mindk~mindk

                                             WHERE gricd~sourceledger       EQ account~sourceledger
                                               AND gricd~companycode        EQ account~companycode
                                               AND gricd~accountingdocument EQ account~accountingdocument
                                               AND gricd~fiscalyear         EQ account~fiscalyear
                                               AND gricd~fiscalyearperiod   EQ account~fiscalyearperiod
                                               AND mg12~hkont               EQ account~glaccount
                                               AND ( ( gricd~isreversal IS INITIAL AND gricd~debitcreditcode EQ 'H' ) OR ( gricd~isreversal EQ @abap_true AND gricd~debitcreditcode  EQ 'S' ) )
                                            )
                            )
                       APPENDING CORRESPONDING FIELDS OF TABLE @et_data.

    SORT et_data BY bukrs gjahr belnr docln ryear fiscyearper hsl wsl.
    DELETE ADJACENT DUPLICATES FROM et_data COMPARING ALL FIELDS.

    "ters kayıtların temizlenmesi
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
      CHECK sy-subrc IS INITIAL.

      DELETE et_data WHERE awref_rev EQ ls_reversed-awref_rev
                       AND aworg_rev EQ ls_reversed-aworg_rev.

      DELETE et_data WHERE awref EQ ls_reversed-awref_rev
                       AND aworg EQ ls_reversed-aworg_rev.

    ENDLOOP.

    lt_lifnr = et_data.
    SORT lt_lifnr BY bukrs lifnr.
    DELETE ADJACENT DUPLICATES FROM lt_lifnr COMPARING bukrs lifnr.

    IF lines( lt_lifnr ) GT 0.

      SELECT a~supplier AS lifnr ,
             a~companycode AS bukrs ,
             b~mindk
             FROM i_suppliercompany AS a
             LEFT OUTER JOIN ztax_t_mindk AS b ON b~bukrs = a~companycode"bukrs
                                              AND b~lifnr = a~supplier"lifnr
             INNER JOIN @lt_lifnr AS lt_lifnr
                ON a~supplier    EQ lt_lifnr~lifnr
               AND a~companycode EQ lt_lifnr~bukrs
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

      SELECT i_operationalacctgdocitem~companycode AS rbukrs ,
             i_operationalacctgdocitem~fiscalyear AS gjahr ,
             i_operationalacctgdocitem~accountingdocument AS belnr ,
             i_operationalacctgdocitem~ledgergllineitem AS docln ,
*             I_OPERATIONALACCTGDOCITEM~LedgerFiscalYear AS ryear ,
*             I_OPERATIONALACCTGDOCITEM~FiscalYearPeriod AS fiscyearper ,
             i_operationalacctgdocitem~amountincompanycodecurrency AS hsl ,
             i_operationalacctgdocitem~amountintransactioncurrency AS wsl ,
             i_operationalacctgdocitem~debitcreditcode AS drcrk ,
*             I_OPERATIONALACCTGDOCITEM~ReversalReferenceDocument AS awref_rev ,
*             I_OPERATIONALACCTGDOCITEM~ReversalReferenceDocumentCntxt AS aworg_rev ,
             i_operationalacctgdocitem~referencedocumenttype AS awtyp ,
*             I_OPERATIONALACCTGDOCITEM~ReferenceDocument AS awref ,
*             I_OPERATIONALACCTGDOCITEM~ReferenceDocumentContext AS aworg ,
*             I_OPERATIONALACCTGDOCITEM~IsReversal AS xreversing ,
*             I_OPERATIONALACCTGDOCITEM~IsReversed AS xreversed ,
             i_operationalacctgdocitem~supplier AS lifnr ,
             i_operationalacctgdocitem~glaccount AS racct ,
             i_operationalacctgdocitem~documentitemtext AS sgtxt ,
             i_operationalacctgdocitem~transactioncurrency AS rwcur ,
             i_operationalacctgdocitem~assignmentreference AS zuonr ,
             i_operationalacctgdocitem~postingdate AS budat ,
             i_operationalacctgdocitem~financialaccounttype AS koart
               FROM i_operationalacctgdocitem
               INNER JOIN @lt_data AS lt_data
               ON
*                     SourceLedger  EQ '0L'
                     companycode   EQ lt_data~bukrs
                 AND fiscalyear    EQ lt_data~gjahr
                 AND accountingdocument  EQ lt_data~belnr
                 AND glaccount  LIKE '191%'
                INTO CORRESPONDING FIELDS OF TABLE @et_data_191.

    ENDIF.

  ENDMETHOD.
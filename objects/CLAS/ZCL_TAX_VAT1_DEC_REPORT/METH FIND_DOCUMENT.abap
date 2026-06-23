  METHOD find_document.

    FIELD-SYMBOLS <fs_bkpf> TYPE mty_bkpf.

    DATA lt_bkpf_rmrp TYPE TABLE OF mty_bkpf.
    DATA lt_bkpf_vbrk TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY awref_rev.
    DATA lt_bkpf_rev  TYPE SORTED TABLE OF mty_bkpf WITH NON-UNIQUE KEY bukrs stblg stjah.
    DATA ls_bkpf_rev_cont TYPE mty_bkpf_rev_cont.
    DATA lt_bkpf_rev_cont TYPE SORTED TABLE OF mty_bkpf_rev_cont WITH UNIQUE KEY bukrs belnr gjahr.
    DATA ls_rbkp TYPE mty_rbkp.
    DATA lt_rbkp TYPE TABLE OF mty_rbkp .
    DATA ls_vbrk TYPE mty_vbrk.
    DATA lt_vbrk TYPE SORTED TABLE OF mty_vbrk WITH UNIQUE KEY vbeln.

    SELECT i_journalentry~companycode AS bukrs,
           i_journalentry~accountingdocument AS belnr,
           i_journalentry~fiscalyear AS gjahr,
           i_journalentry~accountingdocumenttype AS blart,
           i_journalentry~postingdate AS budat,
           i_journalentry~fiscalperiod AS monat,
           i_journalentry~referencedocumenttype AS awtyp,
           i_journalentry~reversalreferencedocument AS awref_rev,
           i_journalentry~reversalreferencedocumentcntxt AS aworg_rev,
           i_journalentry~reversedocument AS stblg,
           i_journalentry~reversedocumentfiscalyear AS stjah,
           i_journalentry~documentreferenceid AS xblnr,
           i_journalentry~documentdate AS bldat
      FROM i_journalentry
      WHERE i_journalentry~companycode EQ @p_bukrs
        AND i_journalentry~fiscalyear EQ @p_gjahr
        AND i_journalentry~fiscalperiod IN @mr_monat
        AND i_journalentry~isreversed = @space
        AND i_journalentry~isreversal = @space
      INTO TABLE @et_bkpf.

    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    IF is_read_tab-bset EQ abap_true.
      IF lines( et_bkpf ) GT 0.

        SELECT bset~companycode         AS bukrs,
               bset~accountingdocument  AS belnr,
               bset~fiscalyear          AS gjahr,
               bset~taxitem             AS buzei,
               bset~taxcode             AS mwskz,
               bset~debitcreditcode     AS shkzg,
               bset~taxbaseamountincocodecrcy AS hwbas,
               bset~taxamountincocodecrcy     AS hwste,
               bset~transactiontypedetermination AS ktosl,
               taxratio~conditionrateratio AS kbetr,
               taxratio~vatconditiontype AS kschl,
               bkpf~blart AS blart,
               docitem~glaccount AS hkont
          FROM i_operationalacctgdoctaxitem AS bset
          INNER JOIN @et_bkpf AS bkpf
            ON bset~companycode        = bkpf~bukrs
           AND bset~accountingdocument = bkpf~belnr
           AND bset~fiscalyear         = bkpf~gjahr
          INNER JOIN i_companycode AS t001
            ON t001~companycode = bset~companycode
          LEFT JOIN i_taxcoderate AS taxratio
            ON taxratio~taxcode = bset~taxcode
           AND taxratio~accountkeyforglaccount = bset~transactiontypedetermination
           AND taxratio~country = t001~country
           AND taxratio~cndnrecordvaliditystartdate <= bkpf~bldat
           AND taxratio~cndnrecordvalidityenddate >= bkpf~bldat
          LEFT JOIN i_operationalacctgdocitem AS docitem
            ON docitem~companycode            = bset~companycode
           AND docitem~accountingdocument     = bset~accountingdocument
           AND docitem~fiscalyear             = bset~fiscalyear
           AND docitem~accountingdocumentitem = bset~taxitem
         INTO CORRESPONDING FIELDS OF TABLE @et_bset.

      ENDIF.
    ENDIF.

    IF is_read_tab-bseg EQ abap_true.
      IF lines( et_bset ) GT 0.

        SELECT companycode AS bukrs,
               accountingdocument AS belnr,
               fiscalyear AS gjahr,
               financialaccounttype AS koart,
               supplier AS lifnr,
               accountingdocumentitemtype AS buzid,
               taxcode AS mwskz,
               glaccount AS hkont,
               reference3idbybusinesspartner AS xref3,
               assignmentreference AS assignmentreference,
               accountingdocumentitem AS buzei
          FROM i_operationalacctgdocitem AS bseg
          INNER JOIN @et_bset AS bset
            ON bseg~companycode        EQ bset~bukrs
           AND bseg~accountingdocument EQ bset~belnr
           AND bseg~fiscalyear         EQ bset~gjahr
         INTO TABLE @et_bseg.

      ELSEIF lines( et_bkpf ) GT 0.

        SELECT companycode AS bukrs,
               accountingdocument AS belnr,
               fiscalyear AS gjahr,
               financialaccounttype AS koart,
               supplier AS lifnr,
               accountingdocumentitemtype AS buzid,
               taxcode AS mwskz,
               glaccount AS hkont,
               reference3idbybusinesspartner AS xref3,
               assignmentreference AS assignmentreference,
               accountingdocumentitem AS buzei
          FROM i_operationalacctgdocitem AS bseg
          INNER JOIN @et_bkpf AS bkpf
            ON bseg~companycode        EQ bkpf~bukrs
           AND bseg~accountingdocument EQ bkpf~belnr
           AND bseg~fiscalyear         EQ bkpf~gjahr
         INTO TABLE @et_bseg.

      ENDIF.
    ENDIF.

  ENDMETHOD.
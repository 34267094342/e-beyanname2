  METHOD find_document .

    "--- ET_BKPF: belge başlığı (kırılım / lv_ita mantığının çalışabilmesi için

    "    dokümanların bukrs/belnr/gjahr bilgisi burada okunur).

    SELECT i_journalentry~CompanyCode AS bukrs,

               i_journalentry~AccountingDocument AS belnr,

               i_journalentry~FiscalYear AS gjahr,

               i_journalentry~AccountingDocumentType AS blart,

               i_journalentry~PostingDate AS budat,

               i_journalentry~FiscalPeriod AS monat,

               i_journalentry~ReferenceDocumentType AS awtyp,

               i_journalentry~ReversalReferenceDocument AS awref_rev,

               i_journalentry~ReversalReferenceDocumentCntxt AS aworg_rev,

               i_journalentry~ReverseDocument AS stblg,

               i_journalentry~ReverseDocumentFiscalYear AS stjah,

               i_journalentry~DocumentReferenceID AS xblnr,

               i_journalentry~DocumentDate AS bldat

          FROM i_journalentry

          WHERE i_journalentry~CompanyCode EQ @p_bukrs

            AND i_journalentry~FiscalYear  EQ @p_gjahr

            AND i_journalentry~FiscalPeriod IN @mr_monat

            AND i_journalentry~IsReversed = @space

            AND i_journalentry~IsReversal = @space

          INTO TABLE @et_bkpf.

    IF is_read_tab-bset EQ abap_true.

      "-----------------------------------------------------------------------

      " DÜZELTME: Artık belge/vergi kodu bazında (taxcode) TOPLANMIYOR.

      " SORUN   : Eski SELECT, aynı belgede aynı vergi koduna (mwskz) sahip

      "           farklı kalemleri (BUZEI) tek satırda topluyordu. Bu da

      "           tevkifat kırılımının (kural=003) kalem bazında ayrılan

      "           ASSIGNMENTREFERENCE bilgisine göre doğru dağıtılmasını

      "           imkansız kılıyordu (kalemler zaten birleşmiş geliyordu).

      " ÇÖZÜM   : SELECT artık kalem (accountingdocumentitem/BUZEI) ve

      "           ASSIGNMENTREFERENCE bazında GROUP BY yapılıyor, böylece her

      "           fiziksel muhasebe kalemi kendi satırında ve kendi

      "           ASSIGNMENTREFERENCE'ı ile geliyor.

      "-----------------------------------------------------------------------

      SELECT

        j~companycode AS bukrs,

        j~accountingdocument AS belnr,

        j~fiscalyear AS gjahr,

        j~accountingdocumentitem AS buzei,

        j~taxcode AS mwskz, r~conditionrateratio AS kbetr, r~vatconditiontype AS kschl,

        j~accountingdocumenttype AS blart, j~glaccount AS hkont,

        j~assignmentreference AS assignmentreference,

        SUM( CASE WHEN ( j~transactiontypedetermination = 'VST' OR j~transactiontypedetermination = 'MWS' )

             THEN j~amountincompanycodecurrency ELSE 0 END ) AS hwste,

        SUM( CASE WHEN ( j~transactiontypedetermination <> 'VST' AND

                         j~transactiontypedetermination <> 'MWS' AND

                         j~transactiontypedetermination <> 'ZTA' ) THEN j~amountincompanycodecurrency ELSE 0 END ) AS hwbas

        FROM i_journalentryitem AS j

        LEFT OUTER JOIN i_taxcoderate AS r

          ON r~cndnrecordvaliditystartdate <= j~documentdate

         AND r~cndnrecordvalidityenddate   >= j~documentdate

         AND r~taxcode = j~taxcode

         AND ( r~accountkeyforglaccount = 'VST' OR r~accountkeyforglaccount = 'MWS' )

        WHERE j~ledger = '0L'

          AND j~companycode = @p_bukrs

          AND j~fiscalyear = @p_gjahr

          AND j~fiscalperiod = @p_monat

          AND ( j~financialaccounttype = 'S' OR j~financialaccounttype = 'A' )

          AND j~taxcode <> ''

        GROUP BY j~companycode, j~accountingdocument, j~fiscalyear, j~accountingdocumentitem,

                 j~taxcode, r~conditionrateratio, r~vatconditiontype, j~accountingdocumenttype,

                 j~glaccount, j~assignmentreference

        ORDER BY j~companycode, j~accountingdocument, j~fiscalyear, j~taxcode

        INTO CORRESPONDING FIELDS OF TABLE @et_bset.

    ENDIF.

    "NOTE: et_bseg (koart/lifnr/xref3 breakdown) is currently not populated here.

  ENDMETHOD.
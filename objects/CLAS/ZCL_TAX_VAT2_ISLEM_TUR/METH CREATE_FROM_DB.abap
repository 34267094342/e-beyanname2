  METHOD create_from_db.

    DATA lt_item      TYPE tt_item.
    DATA ls_item      TYPE ty_item.
    DATA lt_taxitem   TYPE tt_taxitem.
    DATA ls_taxitem   TYPE ty_taxitem.
    DATA lt_ist       TYPE tt_ist.
    DATA lr_mwskz     TYPE RANGE OF mwskz.
    DATA lv_fieldname TYPE string.

    lv_fieldname = iv_fieldname.
    CONDENSE lv_fieldname.
    lv_fieldname = to_upper( lv_fieldname ).

    SELECT k2type,
           mwskz
           FROM ztax_t_k2ist
           INTO TABLE @lt_ist.

    LOOP AT lt_ist INTO DATA(ls_ist).
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_ist-mwskz ) TO lr_mwskz.
    ENDLOOP.
    SORT lr_mwskz BY low.
    DELETE ADJACENT DUPLICATES FROM lr_mwskz COMPARING low.

    IF lines( lr_mwskz ) GT 0.

      SELECT item~companycode                   AS bukrs,
             item~accountingdocument            AS belnr,
             item~fiscalyear                    AS gjahr,
             item~accountingdocumentitem        AS buzei,
             item~financialaccounttype          AS koart,
             item~accountingdocumentitemtype    AS buzid,
             item~taxcode                       AS mwskz,
             item~assignmentreference           AS zuonr,
             item~reference3idbybusinesspartner AS xref3
             FROM i_operationalacctgdocitem AS item
             INNER JOIN i_journalentry AS head
             ON  head~companycode        EQ item~companycode
             AND head~accountingdocument EQ item~accountingdocument
             AND head~fiscalyear         EQ item~fiscalyear
             WHERE head~companycode  EQ @iv_bukrs
               AND head~fiscalyear   EQ @iv_gjahr
               AND head~fiscalperiod IN @ir_monat
               AND head~isreversed   EQ @space
               AND head~isreversal   EQ @space
               AND item~taxcode      IN @lr_mwskz
             INTO TABLE @DATA(lt_db_item).

      LOOP AT lt_db_item INTO DATA(ls_db_item).
        CLEAR ls_item.
        ls_item-bukrs = ls_db_item-bukrs.
        ls_item-belnr = ls_db_item-belnr.
        ls_item-gjahr = ls_db_item-gjahr.
        ls_item-buzei = ls_db_item-buzei.
        ls_item-koart = ls_db_item-koart.
        ls_item-buzid = ls_db_item-buzid.
        ls_item-mwskz = ls_db_item-mwskz.
        CASE lv_fieldname.
          WHEN 'ASSIGNMENTREFERENCE' OR 'ZUONR'.
            ls_item-value = ls_db_item-zuonr.
          WHEN 'XREF3' OR 'REFERENCE3IDBYBUSINESSPARTNER'.
            ls_item-value = ls_db_item-xref3.
        ENDCASE.
        APPEND ls_item TO lt_item.
      ENDLOOP.

      SELECT tax~companycode        AS bukrs,
             tax~accountingdocument AS belnr,
             tax~fiscalyear         AS gjahr,
             tax~taxitem            AS buzei,
             tax~taxcode            AS mwskz
             FROM i_operationalacctgdoctaxitem AS tax
             INNER JOIN i_journalentry AS head
             ON  head~companycode        EQ tax~companycode
             AND head~accountingdocument EQ tax~accountingdocument
             AND head~fiscalyear         EQ tax~fiscalyear
             WHERE head~companycode  EQ @iv_bukrs
               AND head~fiscalyear   EQ @iv_gjahr
               AND head~fiscalperiod IN @ir_monat
               AND head~isreversed   EQ @space
               AND head~isreversal   EQ @space
               AND tax~taxcode       IN @lr_mwskz
             INTO TABLE @DATA(lt_db_tax).

      LOOP AT lt_db_tax INTO DATA(ls_db_tax).
        CLEAR ls_taxitem.
        ls_taxitem-bukrs = ls_db_tax-bukrs.
        ls_taxitem-belnr = ls_db_tax-belnr.
        ls_taxitem-gjahr = ls_db_tax-gjahr.
        ls_taxitem-buzei = ls_db_tax-buzei.
        ls_taxitem-mwskz = ls_db_tax-mwskz.
        APPEND ls_taxitem TO lt_taxitem.
      ENDLOOP.

    ENDIF.

    ro_instance = NEW #( it_item    = lt_item
                         it_taxitem = lt_taxitem
                         it_ist     = lt_ist ).

  ENDMETHOD.
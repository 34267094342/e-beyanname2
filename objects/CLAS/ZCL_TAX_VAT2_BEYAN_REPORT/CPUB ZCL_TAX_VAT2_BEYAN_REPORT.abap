CLASS zcl_tax_vat2_beyan_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .

    DATA mr_monat TYPE RANGE OF monat.
    DATA mv_monat TYPE monat.

    DATA p_monat TYPE monat.
    DATA p_gjahr TYPE gjahr.
    DATA p_bukrs TYPE bukrs.
    DATA p_donemb TYPE ztax_e_donemb.
    DATA p_beyant TYPE ztax_e_beyant.

    TYPES BEGIN OF mty_read_tab.
    TYPES bseg TYPE selkz_08.
    TYPES bset TYPE selkz_08.
    TYPES END OF mty_read_tab.

    TYPES BEGIN OF mty_hesap.
    TYPES hesaptip TYPE n LENGTH 3."/itetr/tax_k2hes-hesaptip.
    TYPES kschl    TYPE kschl.
    TYPES sign(1).
    TYPES amount TYPE p LENGTH 16 DECIMALS 2. "TYPE P LENGTH 23 DECIMALS 2.
    TYPES tax     TYPE p LENGTH 16 DECIMALS 2."TYPE hwste.
    TYPES percent TYPE p LENGTH 16 DECIMALS 2."TYPE kbetr.
    TYPES END OF mty_hesap.

    TYPES mtty_hesap TYPE TABLE OF mty_hesap.

    TYPES BEGIN OF mty_map.
    TYPES kiril1 TYPE ztax_t_k2k1s-kiril1.
    TYPES xmlsr  TYPE ztax_t_k2k1s-xmlsr.
    TYPES kiril2 TYPE ztax_t_k2k2s-kiril2.
    TYPES mwskz  TYPE ztax_t_kdv2g-mwskz.
    TYPES kural  TYPE ztax_t_k2k2s-kural.
    TYPES acklm1 TYPE ztax_t_k2k1-acklm.
    TYPES acklm2 TYPE ztax_t_k2k2-acklm.
    TYPES END OF mty_map.

    TYPES mtty_map TYPE TABLE OF mty_map.

    TYPES mtty_kschl_range TYPE RANGE OF kschl.
    TYPES mtty_mwskz_range TYPE RANGE OF mwskz.

    TYPES BEGIN OF mty_hes.
    TYPES hesaptip TYPE ztax_t_k2hes-hesaptip.
    TYPES hesap    TYPE ztax_t_k2hes-hesap.
    TYPES END OF mty_hes.

    TYPES BEGIN OF mty_bset.
    TYPES bukrs TYPE i_operationalacctgdoctaxitem-companycode.
    TYPES belnr TYPE i_operationalacctgdoctaxitem-accountingdocument.
    TYPES gjahr TYPE i_operationalacctgdoctaxitem-fiscalyear.
    TYPES buzei TYPE i_operationalacctgdoctaxitem-taxitem.
    TYPES mwskz TYPE i_operationalacctgdoctaxitem-taxcode.
    TYPES shkzg TYPE i_operationalacctgdoctaxitem-debitcreditcode.
    TYPES hwbas TYPE i_operationalacctgdoctaxitem-taxbaseamountincocodecrcy.
    TYPES hwste TYPE i_operationalacctgdoctaxitem-taxamountincocodecrcy.
    TYPES kbetr TYPE ztax_e_kbetr."I_OperationalAcctgDocTaxItem-kbetr.
    TYPES kschl TYPE kschl."bset-kschl.
    TYPES hkont TYPE hkont."bset-hkont.
    TYPES END OF mty_bset.

    TYPES BEGIN OF mty_bkpf.
    TYPES bukrs     TYPE i_journalentry-companycode.
    TYPES belnr     TYPE i_journalentry-accountingdocument.
    TYPES gjahr     TYPE i_journalentry-fiscalyear.
    TYPES budat     TYPE i_journalentry-postingdate.
    TYPES monat     TYPE i_journalentry-fiscalperiod.
    TYPES awtyp     TYPE i_journalentry-referencedocumenttype.
    TYPES awref_rev TYPE i_journalentry-reversalreferencedocument.
    TYPES aworg_rev TYPE i_journalentry-reversalreferencedocumentcntxt.
    TYPES stblg     TYPE i_journalentry-reversedocument.
    TYPES stjah     TYPE i_journalentry-reversedocumentfiscalyear.
    TYPES xblnr     TYPE i_journalentry-documentreferenceid.
    TYPES bldat     TYPE i_journalentry-documentdate.
    TYPES gjahr_rev TYPE i_journalentry-fiscalyear.
    TYPES kbetr TYPE ztax_e_kbetr."I_OperationalAcctgDocTaxItem-kbetr.
    TYPES kschl TYPE kschl."bset-kschl.
    TYPES END OF mty_bkpf.
"TEST

    TYPES BEGIN OF mty_bkpf_rev_cont.
    TYPES bukrs TYPE i_journalentry-companycode.
    TYPES belnr TYPE i_journalentry-accountingdocument.
    TYPES gjahr TYPE i_journalentry-fiscalyear.
    TYPES budat TYPE i_journalentry-postingdate.
    TYPES END OF mty_bkpf_rev_cont.

    TYPES mtty_bkpf TYPE SORTED TABLE OF mty_bkpf WITH UNIQUE KEY bukrs belnr gjahr.
    TYPES mtty_bset TYPE SORTED TABLE OF mty_bset WITH UNIQUE KEY bukrs belnr gjahr buzei.


    TYPES BEGIN OF mty_rbkp.
    TYPES belnr TYPE i_supplierinvoiceapi01-supplierinvoice.
    TYPES gjahr TYPE i_supplierinvoiceapi01-fiscalyear.
    TYPES budat TYPE i_supplierinvoiceapi01-postingdate.
    TYPES END OF mty_rbkp.

    TYPES BEGIN OF mty_vbrk.
    TYPES vbeln TYPE i_salesdocument-salesdocument.
    TYPES fkdat TYPE i_salesdocument-salesdocumentdate.
    TYPES END OF mty_vbrk.

    TYPES BEGIN OF mty_collect.
    TYPES kiril1    TYPE ztax_t_kdv2g-kiril1.
    TYPES acklm1    TYPE ztax_t_k2k1-acklm.
    TYPES kiril2    TYPE ztax_t_kdv2g-kiril2.
    TYPES acklm2    TYPE ztax_t_k2k2-acklm.
    TYPES kiril3    TYPE val_text."dd07t-ddtext.
    TYPES matrah    TYPE ztax_ddl_i_vat2_kes_report-matrah.
    TYPES oran      TYPE c LENGTH 10.
    TYPES tevkifat  TYPE ztax_ddl_i_vat2_kes_report-tevkt.
    TYPES tevkifato TYPE c LENGTH 10.
    TYPES vergi     TYPE ztax_ddl_i_vat2_kes_report-vergi.
    TYPES field_com(200) TYPE c.
    TYPES END OF mty_collect.


    TYPES BEGIN OF mty_button_pushed.
    TYPES kdv2 TYPE selkz_08.
    TYPES kes  TYPE selkz_08.
    TYPES END OF mty_button_pushed.



*    TYPES mtty_bset TYPE SORTED TABLE OF mty_bset WITH UNIQUE KEY bukrs belnr gjahr buzei.


    TYPES BEGIN OF mty_bseg.
    TYPES bukrs TYPE bukrs.
    TYPES belnr TYPE belnr_d.
    TYPES gjahr TYPE gjahr.
    TYPES koart TYPE koart.
    TYPES lifnr TYPE lifnr.
    TYPES buzid TYPE c LENGTH 1.
    TYPES mwskz TYPE mwskz.
    TYPES xref3 TYPE  c LENGTH 20.
    TYPES assignmentreference TYPE I_JournalEntryItem-assignmentreference.
    TYPES buzei TYPE i_operationalacctgdocitem-accountingdocumentitem.
    TYPES END OF mty_bseg.
    TYPES mtty_bseg TYPE TABLE OF mty_bseg .

    TYPES mtty_kesinti TYPE TABLE OF ztax_ddl_i_vat2_kes_report.

    DATA mt_hesap                  TYPE mtty_hesap.
    DATA mt_map                    TYPE mtty_map.
    DATA mr_kschl                  TYPE mtty_kschl_range.
    DATA mr_mwskz                  TYPE mtty_mwskz_range.
    DATA mt_bkpf TYPE SORTED TABLE OF mty_bkpf WITH UNIQUE KEY bukrs belnr gjahr.
    DATA mt_bseg TYPE mtty_bseg.
    DATA mt_bset TYPE mtty_bset.
*    DATA mt_kesinti                TYPE TABLE OF ztax_ddl_i_vat2_kes_report.

    DATA ms_button_pushed TYPE mty_button_pushed.

    TYPES BEGIN OF mty_kschl_mwskz.
    TYPES kiril1 TYPE ztax_t_kdv2g-kiril1.
    TYPES acklm1 TYPE ztax_t_k2k1-acklm.
    TYPES kiril2 TYPE ztax_t_kdv2g-kiril2.
    TYPES acklm2 TYPE ztax_t_k2k2-acklm.
    TYPES mwskz  TYPE mwskz.
    TYPES kschl  TYPE kschl.
    TYPES shkzg  TYPE shkzg.
    TYPES kbetr  TYPE c LENGTH 20.
    TYPES hwbas  TYPE p LENGTH 16 DECIMALS 2.
    TYPES hwste  TYPE p LENGTH 16 DECIMALS 2.
    TYPES xmlsr  TYPE ztax_t_k2k1s-xmlsr.
    TYPES END OF mty_kschl_mwskz.

    TYPES mtty_kschl_mwskz TYPE TABLE OF mty_kschl_mwskz.

    TYPES mtty_monat_range TYPE RANGE OF monat.

    CONSTANTS mc_kschl_character TYPE string VALUE 'QWERTYUIOPĞÜASDFGHJKLŞİZXCVBNMÖÇ'.
    CONSTANTS mc_new_line_belnr    TYPE belnr_d VALUE '**********'.

*    DATA mt_collect                TYPE TABLE OF mty_collect.
    DATA mt_collect                TYPE TABLE OF ztax_ddl_i_vat2_beyan_report.

    TYPES mtty_collect TYPE TABLE OF ztax_ddl_i_vat2_beyan_report..

    METHODS :

      fill_monat_range IMPORTING iv_donemb TYPE ztax_e_donemb
                       EXPORTING er_monat  TYPE  mtty_monat_range
                                 ev_monat  TYPE monat,
      fill_shared_structure,
      get_map_tab EXPORTING et_map TYPE mtty_map,
      fill_mwskz_range IMPORTING it_map   TYPE mtty_map
                       EXPORTING er_mwskz TYPE mtty_mwskz_range,

      change_formul_for_abap EXPORTING et_hesap TYPE mtty_hesap,

      hesap EXPORTING et_hesap TYPE mtty_hesap
            CHANGING  cs_hes   TYPE mty_hes,

      fill_kschl_range IMPORTING it_hesap TYPE mtty_hesap
                       EXPORTING er_kschl TYPE mtty_kschl_range,

      filter_kschl_from_formul CHANGING ct_hesap TYPE mtty_hesap,

      find_document IMPORTING is_read_tab TYPE mty_read_tab
                              ir_mwskz    TYPE mtty_mwskz_range
                              ir_kschl    TYPE mtty_kschl_range OPTIONAL
                    EXPORTING et_bkpf     TYPE mtty_bkpf
                              et_bset     TYPE mtty_bset
                              et_bseg     TYPE mtty_bseg,

      fill_amount_fields IMPORTING it_hesap      TYPE mtty_hesap
                                   it_parameters TYPE mtty_hesap
                         CHANGING  cs_collect    TYPE ztax_ddl_i_vat2_beyan_report,

      set_parameter_value IMPORTING iv_kiril1      TYPE ztax_t_kdv2g-kiril1
                                    iv_kiril2      TYPE ztax_t_kdv2g-kiril2
                                    iv_mwskz       TYPE mwskz
                                    it_kschl_mwskz TYPE mtty_kschl_mwskz
                          CHANGING  ct_parameters  TYPE mtty_hesap,


      kdv2 IMPORTING iv_bukrs   TYPE bukrs
                     iv_gjahr   TYPE gjahr
                     iv_monat   TYPE monat
                     iv_donemb  TYPE ztax_e_donemb
                     iv_beyant  TYPE ztax_e_beyant
           EXPORTING et_collect TYPE mtty_collect
                     er_monat   TYPE mtty_monat_range .

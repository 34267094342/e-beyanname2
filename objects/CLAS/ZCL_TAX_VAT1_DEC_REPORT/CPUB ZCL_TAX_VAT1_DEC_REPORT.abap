CLASS zcl_tax_vat1_dec_report DEFINITION
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

    TYPES BEGIN OF mty_bkpf.
    TYPES bukrs     TYPE i_journalentry-companycode.
    TYPES belnr     TYPE i_journalentry-accountingdocument.
    TYPES gjahr     TYPE i_journalentry-fiscalyear.
    TYPES blart     TYPE i_journalentry-accountingdocumenttype.
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
    TYPES END OF mty_bkpf.

*    TYPES mtty_bkpf TYPE SORTED TABLE OF mty_bkpf WITH UNIQUE KEY bukrs belnr gjahr.
    TYPES mtty_bkpf TYPE TABLE OF mty_bkpf.

    TYPES BEGIN OF mty_bset.
    TYPES bukrs TYPE bukrs.
    TYPES belnr TYPE belnr_d.
    TYPES gjahr TYPE gjahr.
    TYPES buzei TYPE buzei.
    TYPES mwskz TYPE mwskz.
    TYPES shkzg TYPE shkzg.
    TYPES hwbas TYPE p LENGTH 16 DECIMALS 2.
    TYPES hwste TYPE p LENGTH 16 DECIMALS 2. "hwste.
    TYPES ktosl TYPE ktosl.
    TYPES kbetr TYPE int4.
    TYPES kschl TYPE kschl.
    TYPES blart TYPE blart.
    TYPES hkont TYPE hkont.

    TYPES END OF mty_bset.
*    TYPES mtty_bset TYPE SORTED TABLE OF mty_bset WITH UNIQUE KEY bukrs belnr gjahr buzei.
    TYPES mtty_bset TYPE TABLE OF mty_bset .

    TYPES mtty_saknr_range TYPE RANGE OF saknr.
    TYPES mtty_mwskz_range TYPE RANGE OF mwskz.

    TYPES BEGIN OF mty_map.
    TYPES kiril1 TYPE ztax_t_k1k1s-kiril1.
    TYPES xmlsr  TYPE ztax_t_k1k1s-xmlsr.
    TYPES kiril2 TYPE ztax_t_k1k2s-kiril2.
    TYPES mwskz  TYPE ztax_t_kdv1g-mwskz.
    TYPES saknr  TYPE ztax_t_kdv1g-saknr.
    TYPES topal  TYPE ztax_t_kdv1g-topal.
    TYPES topalk TYPE ztax_t_kdv1g-topalk.
    TYPES shkzg  TYPE ztax_t_kdv1g-shkzg.
    TYPES islem_tur TYPE ztax_t_kdv1g-islem_tur. "YiğitcanÖzdemir
    TYPES odeme_tur TYPE ztax_t_kdv1g-odeme_tur. "YiğitcanÖzdemir
    TYPES kural  TYPE ztax_t_k1k2s-kural.
    TYPES acklm1 TYPE ztax_t_k1k1-acklm.
    TYPES acklm2 TYPE ztax_t_k1k2-acklm.
    TYPES blart TYPE ztax_t_kdv1g-blart.

    TYPES END OF mty_map.

    TYPES mtty_map TYPE TABLE OF mty_map.

    TYPES BEGIN OF lty_k1mt.
    TYPES bukrs    TYPE ztax_t_k1mt-bukrs.
    TYPES gjahr    TYPE ztax_t_k1mt-gjahr.
    TYPES monat    TYPE ztax_t_k1mt-monat.
    TYPES kiril1   TYPE ztax_t_k1mt-kiril1.
    TYPES kiril2   TYPE ztax_t_k1mt-kiril2.
    TYPES mwskz    TYPE ztax_t_k1mt-mwskz.
    TYPES kschl    TYPE ztax_t_k1mt-kschl.
    TYPES hkont    TYPE ztax_t_k1mt-hkont.
    TYPES matrah   TYPE ztax_t_k1mt-matrah.
    TYPES vergi    TYPE ztax_t_k1mt-vergi.
    TYPES tevkt    TYPE ztax_t_k1mt-tevkt.
    TYPES manuel   TYPE ztax_t_k1mt-manuel.
    TYPES vergidis TYPE ztax_t_k1mt-vergidis.
    TYPES vergiic  TYPE ztax_t_k1mt-vergiic.
    TYPES END OF lty_k1mt.

    TYPES BEGIN OF lty_topal.
    TYPES split TYPE c LENGTH 10.
    TYPES END OF lty_topal.

    TYPES BEGIN OF mty_kostr.
    TYPES bukrs  TYPE ztax_t_kostr-bukrs.
    TYPES kiril2 TYPE ztax_t_kostr-kiril2.
    TYPES kosult TYPE ztax_t_kostr-kosult.
    TYPES END OF mty_kostr.

    TYPES mtty_kostr TYPE TABLE OF mty_kostr.

    TYPES BEGIN OF mty_bseg.
    TYPES bukrs TYPE bukrs.
    TYPES belnr TYPE belnr_d.
    TYPES gjahr TYPE gjahr.
    TYPES koart  TYPE koart .
    TYPES lifnr  TYPE lifnr .
    TYPES buzid  TYPE c LENGTH 1 .
    TYPES mwskz  TYPE mwskz .
    TYPES hkont  TYPE hkont .
    TYPES xref3 TYPE  c LENGTH 20.
    TYPES END OF mty_bseg.

*    TYPES mtty_bseg TYPE SORTED TABLE OF mty_bseg WITH UNIQUE KEY bukrs belnr gjahr koart .
    TYPES mtty_bseg TYPE TABLE OF mty_bseg.

    TYPES BEGIN OF mty_bkpf_rev_cont.
    TYPES bukrs TYPE i_journalentry-companycode.
    TYPES belnr TYPE i_journalentry-accountingdocument.
    TYPES gjahr TYPE i_journalentry-fiscalyear.
    TYPES budat TYPE i_journalentry-postingdate.
    TYPES END OF mty_bkpf_rev_cont.

    TYPES BEGIN OF mty_rbkp.
    TYPES belnr TYPE i_supplierinvoiceapi01-supplierinvoice.
    TYPES gjahr TYPE i_supplierinvoiceapi01-fiscalyear.
    TYPES budat TYPE i_supplierinvoiceapi01-postingdate.
    TYPES END OF mty_rbkp.

    TYPES BEGIN OF mty_vbrk.
    TYPES vbeln TYPE i_billingdocumentbasic-billingdocument.
    TYPES fkdat TYPE i_billingdocumentbasic-billingdocumentdate.
    TYPES END OF mty_vbrk.

    TYPES BEGIN OF mty_collect.
    TYPES kiril1    TYPE ztax_t_kdv1g-kiril1.
    TYPES acklm1    TYPE ztax_e_acklm.
    TYPES kiril2    TYPE ztax_t_kdv1g-kiril2.
    TYPES acklm2    TYPE ztax_e_acklm.
    TYPES kiril3    TYPE ztax_e_acklm.
    TYPES islem_turu    TYPE ztax_ddl_i_vat1_dec_report-islem_tur.
    TYPES matrah    TYPE ztax_ddl_i_vat1_dec_report-matrah.
    TYPES oran      TYPE ztax_ddl_i_vat1_dec_report-oran.
    TYPES tevkifat  TYPE ztax_ddl_i_vat1_dec_report-tevkifat.
    TYPES tevkifato TYPE ztax_ddl_i_vat1_dec_report-tevkifato.
    TYPES vergi     TYPE ztax_ddl_i_vat1_dec_report-vergi.
    TYPES END OF mty_collect.

    TYPES BEGIN OF mty_tevita.
    TYPES fieldname     TYPE ztax_t_tevit-fieldname.
    TYPES END OF mty_tevita.
    TYPES mtty_tevita   TYPE TABLE OF mty_tevita.

    DATA mt_tevita      TYPE mtty_tevita.

    TYPES BEGIN OF mty_gib.
    TYPES fieldname     TYPE ztax_t_gib-fieldname_.
    TYPES alan          TYPE ztax_t_gib-alan.
    TYPES END OF mty_gib.
    TYPES mtty_gib   TYPE TABLE OF mty_gib.


    TYPES BEGIN OF mty_button_pushed.
    TYPES kdv1 TYPE selkz_08.
    TYPES tevk TYPE selkz_08.
    TYPES END OF mty_button_pushed.

    DATA ms_button_pushed TYPE mty_button_pushed.

    DATA mv_kural       TYPE ztax_t_k1k2s-kural.
    DATA mr_kural_add   TYPE RANGE OF ztax_t_k1k2s-kural.
    DATA mr_kural_det   TYPE RANGE OF ztax_t_k1k2s-kural.
    DATA mt_gib      TYPE mtty_gib.

    CONSTANTS mc_kschl_character TYPE string VALUE 'QWERTYUIOPĞÜASDFGHJKLŞİZXCVBNMÖÇ'.
    CONSTANTS mc_new_line_belnr    TYPE belnr_d VALUE '**********'.

    DATA mt_collect                TYPE TABLE OF ztax_ddl_i_vat1_dec_report."mty_collect.

    TYPES mtty_collect TYPE TABLE OF ztax_ddl_i_vat1_dec_report..

    TYPES mtty_monat_range TYPE RANGE OF monat.

    METHODS:
      fill_monat_range,
      fill_det_kural_range,
      kdv1 IMPORTING iv_bukrs   TYPE bukrs OPTIONAL
                     iv_gjahr   TYPE gjahr OPTIONAL
                     iv_monat   TYPE monat OPTIONAL
                     iv_donemb  TYPE ztax_e_donemb OPTIONAL
                     iv_beyant  TYPE ztax_e_beyant OPTIONAL
           EXPORTING et_collect TYPE mtty_collect
                     er_monat   TYPE mtty_monat_range ,
      get_condition_type EXPORTING et_kostr TYPE mtty_kostr,
      get_map_tab EXPORTING et_map TYPE mtty_map ,
      fill_saknr_range IMPORTING it_map   TYPE mtty_map
                       EXPORTING er_saknr TYPE mtty_saknr_range,
      get_prev_balance EXPORTING ev_balance TYPE ztax_t_thlog-wrbtr,
      find_document IMPORTING is_read_tab TYPE mty_read_tab
                              ir_saknr    TYPE mtty_saknr_range OPTIONAL
                              ir_mwskz    TYPE mtty_mwskz_range OPTIONAL
                    EXPORTING et_bkpf     TYPE mtty_bkpf
                              et_bset     TYPE mtty_bset
                              et_bseg     TYPE mtty_bseg,
      get_fieldname EXPORTING et_tevita TYPE mtty_tevita,
      get_gib EXPORTING et_gib TYPE mtty_gib,
      calculate_sum_balance IMPORTING is_map   TYPE mty_map
                                      iv_bukrs TYPE bukrs
                                      iv_gjahr TYPE gjahr
                                      iv_monat TYPE monat
                                      iv_butxt TYPE i_companycode-companycodename
                                      is_bset  TYPE mty_bset
                                      it_bkpf  TYPE mtty_bkpf
                                      it_bseg  TYPE mtty_bseg.
    .

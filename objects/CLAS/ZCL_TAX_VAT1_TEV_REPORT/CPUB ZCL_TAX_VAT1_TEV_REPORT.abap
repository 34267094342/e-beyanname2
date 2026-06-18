CLASS zcl_tax_vat1_tev_report DEFINITION
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

    TYPES BEGIN OF lty_kna1.
    TYPES kunnr TYPE i_customer-Customer.
    TYPES name1 TYPE i_customer-OrganizationBPName1.
    TYPES name2 TYPE i_customer-OrganizationBPName2.
    TYPES stcd2 TYPE i_customer-TaxNumber2.
    TYPES END OF lty_kna1.

    TYPES BEGIN OF lty_lfa1.
    TYPES lifnr TYPE i_supplier-Supplier.
    TYPES name1 TYPE i_supplier-OrganizationBPName1.
    TYPES name2 TYPE i_supplier-OrganizationBPName2.
    TYPES stcd2 TYPE i_supplier-TaxNumber2.
    TYPES END OF lty_lfa1.

    TYPES BEGIN OF lty_split.
    TYPES value(50).
    TYPES END OF lty_split.

    TYPES BEGIN OF mty_read_tab.
    TYPES bseg TYPE selkz_08.
    TYPES bset TYPE selkz_08.
    TYPES END OF mty_read_tab.

    TYPES BEGIN OF mty_bkpf.
    TYPES bukrs     TYPE i_journalentry-CompanyCode.
    TYPES belnr     TYPE i_journalentry-AccountingDocument.
    TYPES gjahr     TYPE i_journalentry-FiscalYear.
    TYPES blart     TYPE i_journalentry-AccountingDocumentType.
    TYPES budat     TYPE i_journalentry-PostingDate.
    TYPES monat     TYPE i_journalentry-FiscalPeriod.
    TYPES awtyp     TYPE i_journalentry-ReferenceDocumentType.
    TYPES awref_rev TYPE i_journalentry-ReversalReferenceDocument.
    TYPES aworg_rev TYPE i_journalentry-ReversalReferenceDocumentCntxt.
    TYPES stblg     TYPE i_journalentry-ReverseDocument.
    TYPES stjah     TYPE i_journalentry-ReverseDocumentFiscalYear.
    TYPES xblnr     TYPE i_journalentry-DocumentReferenceID.
    TYPES bldat     TYPE i_journalentry-DocumentDate.
    TYPES gjahr_rev TYPE i_journalentry-FiscalYear.
    TYPES END OF mty_bkpf.

    TYPES mtty_bkpf TYPE  TABLE OF mty_bkpf ."WITH UNIQUE KEY bukrs belnr gjahr.

    TYPES BEGIN OF mty_bseg.
    INCLUDE TYPE I_OperationalAcctgDocItem.
    TYPES END OF mty_bseg.
    TYPES mtty_bseg TYPE  TABLE OF mty_bseg ."WITH UNIQUE KEY CompanyCode AccountingDocument FiscalYear AccountingDocumentItem .


    TYPES BEGIN OF mty_bset.
    TYPES bukrs TYPE bukrs.
    TYPES belnr TYPE belnr_d.
    TYPES gjahr TYPE gjahr.
    TYPES buzei TYPE buzei.
    TYPES mwskz TYPE mwskz.
    TYPES shkzg TYPE shkzg.
    TYPES hwbas TYPE p LENGTH 16 DECIMALS 2.
    TYPES hwste TYPE p LENGTH 16 DECIMALS 2.
    TYPES kbetr TYPE int4.
    TYPES kschl TYPE kschl.
    TYPES hkont TYPE hkont.
    TYPES ktosl TYPE ktosl.
    TYPES END OF mty_bset.
    TYPES mtty_bset TYPE  TABLE OF mty_bset. "WITH UNIQUE KEY bukrs belnr gjahr buzei.

    TYPES BEGIN OF mty_map.
    TYPES kiril1 TYPE ztax_t_k1k1s-kiril1.
    TYPES xmlsr  TYPE ztax_t_k1k1s-xmlsr.
    TYPES kiril2 TYPE ztax_t_k1k2s-kiril2.
    TYPES mwskz  TYPE ztax_t_kdv1g-mwskz.
    TYPES saknr  TYPE ztax_t_kdv1g-saknr.
    TYPES topal  TYPE ztax_t_kdv1g-topal.
    TYPES topalk TYPE ztax_t_kdv1g-topalk.
    TYPES shkzg  TYPE ztax_t_kdv1g-shkzg.
    TYPES kural  TYPE ztax_t_k1k2s-kural.
    TYPES acklm1 TYPE ztax_t_k1k1-acklm.
    TYPES acklm2 TYPE ztax_t_k1k2-acklm.
    TYPES END OF mty_map.

    TYPES mtty_map TYPE TABLE OF mty_map.

    TYPES BEGIN OF mty_tevita.
    TYPES fieldname     TYPE ztax_t_tevit-fieldname.
    TYPES END OF mty_tevita.
    TYPES mtty_tevita   TYPE TABLE OF mty_tevita.
    TYPES mtty_mwskz_range TYPE RANGE OF mwskz.
    TYPES mtty_saknr_range TYPE RANGE OF saknr.

    TYPES BEGIN OF mty_bkpf_rev_cont.
    TYPES bukrs TYPE i_journalentry-CompanyCode.
    TYPES belnr TYPE i_journalentry-AccountingDocument.
    TYPES gjahr TYPE i_journalentry-FiscalYear.
    TYPES budat TYPE i_journalentry-PostingDate.
    TYPES END OF mty_bkpf_rev_cont.

    TYPES BEGIN OF mty_rbkp.
    TYPES belnr TYPE i_supplierinvoiceapi01-SupplierInvoice.
    TYPES gjahr TYPE i_supplierinvoiceapi01-FiscalYear.
    TYPES budat TYPE i_supplierinvoiceapi01-PostingDate.
    TYPES END OF mty_rbkp.

    TYPES BEGIN OF mty_vbrk.
    TYPES vbeln TYPE i_billingdocumentbasic-BillingDocument.
    TYPES fkdat TYPE i_billingdocumentbasic-BillingDocumentDate.
    TYPES END OF mty_vbrk.

    DATA mt_tevita            TYPE mtty_tevita.
    DATA ls_read_tab          TYPE mty_read_tab.
    DATA lt_bkpf              TYPE mtty_bkpf.
    DATA ls_bkpf              TYPE mty_bkpf.
    DATA ls_bseg              TYPE mty_bseg.
    DATA lt_bseg              TYPE mtty_bseg.
    DATA ls_bset              TYPE mty_bset.
    DATA lt_bset              TYPE mtty_bset.
    DATA lt_map               TYPE mtty_map.
    DATA ls_map               TYPE mty_map.
    DATA lr_mwskz             TYPE RANGE OF I_OperationalAcctgDocItem-TaxCode. "mwskz yerine bu yazılmış
    DATA lt_belnr             TYPE mtty_bset.
    DATA ls_belnr             TYPE mty_bset.
    DATA lt_bseg_koart        TYPE  TABLE OF mty_bseg ."WITH NON-UNIQUE KEY CompanyCode AccountingDocument FiscalYear.
    DATA lt_bseg_buzid        TYPE  TABLE OF mty_bseg ."WITH NON-UNIQUE KEY CompanyCode AccountingDocument FiscalYear.
    DATA ls_kna1              TYPE lty_kna1.
    DATA lt_kna1              TYPE  TABLE OF lty_kna1 ."WITH UNIQUE KEY kunnr.
    DATA ls_lfa1              TYPE lty_lfa1.
    DATA lt_lfa1              TYPE  TABLE OF lty_lfa1." WITH UNIQUE KEY lifnr.
    DATA ls_tevkifat          TYPE ztax_ddl_i_vat1_tev_report.
*    DATA lo_data              TYPE REF TO data.
    DATA lo_data_line         TYPE REF TO data.
    DATA lt_split             TYPE TABLE OF lty_split.
    DATA ls_split             TYPE lty_split.
    DATA ls_tevita            TYPE mty_tevita.
    DATA lt_kunnr             TYPE TABLE OF mty_bseg.
    DATA lt_lifnr             TYPE TABLE OF mty_bseg.

    DATA lv_percent_h         TYPE i.
    DATA lv_percent_s         TYPE i.
    DATA lv_percent(20).

    DATA lv_heskdv TYPE p LENGTH 16 DECIMALS 2.
    DATA lv_percent_dec TYPE p DECIMALS 3 LENGTH 15.

    TYPES mtty_tevk TYPE TABLE OF ztax_ddl_i_vat1_tev_report.

    TYPES BEGIN OF mty_button_pushed.
    TYPES kdv1 TYPE selkz_08.
    TYPES tev  TYPE selkz_08.
    TYPES END OF mty_button_pushed.
    DATA ms_button_pushed TYPE mty_button_pushed.
    CONSTANTS mc_hyphen                 VALUE '-'.
*  PROTECTED SECTION.

    METHODS:
      get_data IMPORTING iv_bukrs  TYPE bukrs
                         iv_gjahr  TYPE gjahr
                         iv_monat  TYPE monat
                         iv_donemb TYPE ztax_e_donemb
               EXPORTING et_result TYPE mtty_tevk,
      fill_monat_range,
      get_map_tab EXPORTING et_map TYPE mtty_map,
      fill_mwskz IMPORTING it_map   TYPE mtty_map
                 EXPORTING er_mwskz TYPE mtty_mwskz_range,
      get_fieldname EXPORTING et_tevita TYPE mtty_tevita,
      create_dynamic_tab IMPORTING iv_str_name TYPE clike
                                   it_field    TYPE mtty_tevita
                         EXPORTING eo_data     TYPE REF TO data,
*                                   et_fcat     TYPE lvc_t_fcat.
      find_document IMPORTING is_read_tab TYPE mty_read_tab
                              ir_saknr    TYPE mtty_saknr_range OPTIONAL
                              ir_mwskz    TYPE mtty_mwskz_range OPTIONAL
                    EXPORTING et_bkpf     TYPE mtty_bkpf
                              et_bset     TYPE mtty_bset
                              et_bseg     TYPE mtty_bseg.

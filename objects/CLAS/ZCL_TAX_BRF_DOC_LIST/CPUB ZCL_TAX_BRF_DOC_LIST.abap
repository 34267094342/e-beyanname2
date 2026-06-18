CLASS zcl_tax_brf_doc_list DEFINITION
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

    TYPES BEGIN OF mty_collect.
    TYPES kiril1  TYPE ztax_t_mg-kiril1.
    TYPES acklm1  TYPE ztax_t_mk1-acklm.
    TYPES kiril2  TYPE ztax_t_mg-kiril2.
    TYPES acklm2  TYPE ztax_t_mk1-acklm.
    TYPES kiril3(120).
    TYPES gyst    TYPE p LENGTH 13 DECIMALS 2 .
    TYPES kst     TYPE p LENGTH 13 DECIMALS 2.
    TYPES END OF mty_collect.

    TYPES BEGIN OF mty_mg.
    TYPES bukrs  TYPE ztax_t_mg-bukrs.
    TYPES kiril1 TYPE ztax_t_mg-kiril1.
    TYPES acklm1 TYPE ztax_t_mk1-acklm.
    TYPES kiril2 TYPE ztax_t_mg-kiril2.
    TYPES acklm2 TYPE ztax_t_mk2-acklm.
    TYPES hkont  TYPE ztax_t_mg-hkont.
    TYPES txt50  TYPE i_glaccounttext-glaccountlongname."skat-txt50.
    TYPES mindk  TYPE ztax_t_mg-mindk.
    TYPES mtext  TYPE c LENGTH 30."t059t-mtext.
    TYPES END OF mty_mg.

    TYPES mtty_mg      TYPE TABLE OF mty_mg.

    TYPES BEGIN OF mty_data.
    TYPES bukrs       TYPE i_glaccountlineitemrawdata-companycode.
    TYPES gjahr       TYPE i_glaccountlineitemrawdata-fiscalyear.
    TYPES belnr       TYPE i_glaccountlineitemrawdata-accountingdocument.
    TYPES docln       TYPE i_glaccountlineitemrawdata-ledgergllineitem.
    TYPES ryear       TYPE i_glaccountlineitemrawdata-ledgerfiscalyear.
    TYPES fiscyearper TYPE i_glaccountlineitemrawdata-fiscalyearperiod.
    TYPES hsl         TYPE i_glaccountlineitemrawdata-amountincompanycodecurrency.
    TYPES wsl         TYPE i_glaccountlineitemrawdata-amountintransactioncurrency.
    TYPES drcrk       TYPE i_glaccountlineitemrawdata-debitcreditcode.
    TYPES awref_rev   TYPE i_glaccountlineitemrawdata-reversalreferencedocument.
    TYPES aworg_rev   TYPE i_glaccountlineitemrawdata-reversalreferencedocumentcntxt.
    TYPES awtyp       TYPE i_glaccountlineitemrawdata-referencedocumenttype.
    TYPES awref       TYPE i_glaccountlineitemrawdata-referencedocument.
    TYPES aworg       TYPE i_glaccountlineitemrawdata-referencedocumentcontext.
    TYPES xreversing  TYPE i_glaccountlineitemrawdata-isreversal.
    TYPES xreversed   TYPE i_glaccountlineitemrawdata-isreversed.
    TYPES lifnr       TYPE i_glaccountlineitemrawdata-supplier.
    TYPES racct       TYPE i_glaccountlineitemrawdata-glaccount.
    TYPES txt50       TYPE i_glaccounttext-glaccountlongname.
    TYPES sgtxt       TYPE i_glaccountlineitemrawdata-documentitemtext.
    TYPES name1       TYPE i_supplier-organizationbpname1.
    TYPES name2       TYPE i_supplier-organizationbpname2.
    TYPES name_org1   TYPE i_businesspartner-organizationbpname1.
    TYPES name_org2   TYPE i_businesspartner-organizationbpname2.
    TYPES rwcur       TYPE i_glaccountlineitemrawdata-transactioncurrency.
    TYPES zuonr       TYPE i_glaccountlineitemrawdata-assignmentreference.
    TYPES butxt       TYPE i_companycode-companycodename.
    TYPES xblnr       TYPE i_journalentry-documentreferenceid.
    TYPES budat       TYPE i_glaccountlineitemrawdata-postingdate.
    TYPES stras       TYPE i_supplier-streetname.
*    TYPES mcod3       TYPE c LENGTH 25."I_SUPPLIER-mcod3.
    TYPES regio       TYPE i_supplier-region.
    TYPES land1       TYPE i_supplier-country.
    TYPES stcd2       TYPE i_supplier-taxnumber2.
    TYPES koart       TYPE i_glaccountlineitemrawdata-financialaccounttype.
    TYPES witht       TYPE i_withholdingtaxitem-withholdingtaxtype.
    TYPES wt_withcd   TYPE i_withholdingtaxitem-withholdingtaxcode.
    TYPES taxamount   TYPE i_withholdingtaxitem-whldgtaxamtincocodecrcy.
    TYPES baseamount  TYPE i_withholdingtaxitem-whldgtaxbaseamtincocodecrcy.
    TYPES END OF mty_data.

    TYPES mtty_data    TYPE TABLE OF mty_data.

    TYPES BEGIN OF mty_data_191.
    TYPES rbukrs      TYPE i_glaccountlineitemrawdata-companycode. "rbukrs.
    TYPES gjahr       TYPE i_glaccountlineitemrawdata-fiscalyear. "gjahr.
    TYPES belnr       TYPE i_glaccountlineitemrawdata-accountingdocument. "belnr.
    TYPES docln       TYPE i_glaccountlineitemrawdata-ledgergllineitem. "docln.
    TYPES ryear       TYPE i_glaccountlineitemrawdata-ledgerfiscalyear. "ryear.
    TYPES fiscyearper TYPE i_glaccountlineitemrawdata-fiscalyearperiod. "fiscyearper.
    TYPES hsl         TYPE i_glaccountlineitemrawdata-amountincompanycodecurrency. "hsl.
    TYPES wsl         TYPE i_glaccountlineitemrawdata-amountintransactioncurrency. "wsl.
    TYPES drcrk       TYPE i_glaccountlineitemrawdata-debitcreditcode. "drcrk.
    TYPES awref_rev   TYPE i_glaccountlineitemrawdata-reversalreferencedocument. "awref_rev.
    TYPES aworg_rev   TYPE i_glaccountlineitemrawdata-reversalreferencedocumentcntxt. "aworg_rev.
    TYPES awtyp       TYPE i_glaccountlineitemrawdata-referencedocumenttype. "awtyp.
    TYPES awref       TYPE i_glaccountlineitemrawdata-referencedocument. "awref.
    TYPES aworg       TYPE i_glaccountlineitemrawdata-referencedocumentcontext. "aworg.
    TYPES xreversing  TYPE i_glaccountlineitemrawdata-isreversal. "xreversing.
    TYPES xreversed   TYPE i_glaccountlineitemrawdata-isreversed. "xreversed.
    TYPES lifnr       TYPE i_glaccountlineitemrawdata-supplier. "lifnr.
    TYPES racct       TYPE i_glaccountlineitemrawdata-glaccount. "racct.
    TYPES sgtxt       TYPE i_glaccountlineitemrawdata-documentitemtext. "sgtxt.
    TYPES rwcur       TYPE i_glaccountlineitemrawdata-transactioncurrency. "rwcur.
    TYPES zuonr       TYPE i_glaccountlineitemrawdata-assignmentreference. "zuonr.
    TYPES budat       TYPE i_glaccountlineitemrawdata-postingdate. "budat.
    TYPES koart       TYPE i_glaccountlineitemrawdata-financialaccounttype. "koart.
    TYPES END OF mty_data_191.

    TYPES mtty_data_191 TYPE TABLE OF mty_data_191.

    TYPES BEGIN OF mty_lfb1.
    TYPES lifnr TYPE i_suppliercompany-supplier. "lifnr.
    TYPES bukrs TYPE i_suppliercompany-companycode. "bukrs.
    TYPES mindk TYPE i_suppliercompany-minoritygroup. "mindk.
    TYPES END OF mty_lfb1.

    TYPES mtty_lfb1    TYPE TABLE OF mty_lfb1.

    TYPES BEGIN OF mty_button_pushed.
    TYPES bel TYPE selkz_08.
    TYPES ode TYPE selkz_08.
    TYPES isy TYPE selkz_08.
    TYPES END OF mty_button_pushed.

    TYPES mtty_details TYPE TABLE OF ztax_ddl_i_brf_detail.
    DATA mt_collect    TYPE TABLE OF mty_collect.

    DATA mt_detail     TYPE mtty_details.

    DATA ms_button_pushed TYPE mty_button_pushed.

    CONSTANTS BEGIN OF mc_range_att.
    CONSTANTS sign   TYPE c LENGTH 4 VALUE 'SIGN'.
    CONSTANTS option TYPE c LENGTH 6 VALUE 'OPTION'.
    CONSTANTS low    TYPE c LENGTH 4 VALUE 'LOW'.
    CONSTANTS high   TYPE c LENGTH 4 VALUE 'HIGH'.
    CONSTANTS END OF mc_range_att.

    TYPES mtty_collect TYPE TABLE OF ztax_ddl_i_brf_doc_list..
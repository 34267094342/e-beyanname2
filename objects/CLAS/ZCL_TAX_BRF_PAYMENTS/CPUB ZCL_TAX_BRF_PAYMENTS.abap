CLASS zcl_tax_brf_payments DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

    DATA p_monat TYPE monat.
    DATA p_gjahr TYPE gjahr.
    DATA p_bukrs TYPE bukrs.
    DATA p_donemb TYPE ztax_e_donemb.


    TYPES mtty_ode     TYPE TABLE OF ztax_ddl_i_brf_payments.

    TYPES BEGIN OF mty_mg.
    TYPES bukrs  TYPE ztax_t_mg-bukrs.
    TYPES kiril1 TYPE ztax_t_mg-kiril1.
    TYPES acklm1 TYPE ztax_t_mk1-acklm.
    TYPES kiril2 TYPE ztax_t_mg-kiril2.
    TYPES acklm2 TYPE ztax_t_mk2-acklm.
    TYPES hkont  TYPE ztax_t_mg-hkont.
    TYPES txt50  TYPE c LENGTH 50.
    TYPES mindk  TYPE ztax_t_mg-mindk.
    TYPES mtext   TYPE c LENGTH 30."t059t-mtext.
    TYPES END OF mty_mg.

    TYPES BEGIN OF mty_lfb1.
    TYPES lifnr TYPE lifnr.
    TYPES bukrs TYPE bukrs.
    TYPES mindk TYPE ztax_e_mindk.
    TYPES END OF mty_lfb1.


    TYPES BEGIN OF mty_data.
    TYPES bukrs       TYPE i_glaccountlineitemrawdata-CompanyCode.
    TYPES gjahr       TYPE i_glaccountlineitemrawdata-FiscalYear.
    TYPES belnr       TYPE i_glaccountlineitemrawdata-AccountingDocument.
    TYPES docln       TYPE i_glaccountlineitemrawdata-LedgerGLLineItem.
    TYPES ryear       TYPE i_glaccountlineitemrawdata-LedgerFiscalYear.
    TYPES fiscyearper TYPE i_glaccountlineitemrawdata-FiscalYearPeriod.
    TYPES hsl         TYPE i_glaccountlineitemrawdata-AmountInCompanyCodeCurrency.
    TYPES wsl         TYPE i_glaccountlineitemrawdata-AmountInTransactionCurrency.
    TYPES drcrk       TYPE i_glaccountlineitemrawdata-DebitCreditCode.
    TYPES awref_rev   TYPE i_glaccountlineitemrawdata-ReversalReferenceDocument.
    TYPES aworg_rev   TYPE i_glaccountlineitemrawdata-ReversalReferenceDocumentCntxt.
    TYPES awtyp       TYPE i_glaccountlineitemrawdata-ReferenceDocumentType.
    TYPES awref       TYPE i_glaccountlineitemrawdata-ReferenceDocument.
    TYPES aworg       TYPE i_glaccountlineitemrawdata-ReferenceDocumentContext.
    TYPES xreversing  TYPE i_glaccountlineitemrawdata-IsReversal.
    TYPES xreversed   TYPE i_glaccountlineitemrawdata-IsReversed.
    TYPES lifnr       TYPE i_glaccountlineitemrawdata-Supplier.
    TYPES racct       TYPE i_glaccountlineitemrawdata-GLAccount.
    TYPES txt50       TYPE i_glaccounttext-GLAccountLongName.
    TYPES sgtxt       TYPE i_glaccountlineitemrawdata-DocumentItemText.
    TYPES name1       TYPE i_supplier-OrganizationBPName1.
    TYPES name2       TYPE i_supplier-OrganizationBPName2.
    TYPES name_org1   TYPE i_businesspartner-OrganizationBPName1.
    TYPES name_org2   TYPE i_businesspartner-OrganizationBPName2.
    TYPES rwcur       TYPE i_glaccountlineitemrawdata-TransactionCurrency.
    TYPES zuonr       TYPE i_glaccountlineitemrawdata-AssignmentReference.
    TYPES butxt       TYPE i_companycode-CompanyCodeName.
    TYPES xblnr       TYPE i_journalentry-DocumentReferenceID.
    TYPES budat       TYPE i_glaccountlineitemrawdata-PostingDate.
    TYPES stras       TYPE i_supplier-StreetName.
*    TYPES mcod3       TYPE c LENGTH 25."I_SUPPLIER-mcod3.
    TYPES regio       TYPE i_supplier-Region.
    TYPES land1       TYPE i_supplier-Country.
    TYPES stcd2       TYPE i_supplier-TaxNumber2.
    TYPES koart       TYPE i_glaccountlineitemrawdata-FinancialAccountType.
    TYPES witht       TYPE i_withholdingtaxitem-withholdingtaxtype.
    TYPES wt_withcd   TYPE i_withholdingtaxitem-withholdingtaxcode.
    TYPES taxamount   TYPE i_withholdingtaxitem-whldgtaxamtincocodecrcy.
    TYPES baseamount  TYPE i_withholdingtaxitem-whldgtaxbaseamtincocodecrcy.
    TYPES END OF mty_data.

    TYPES BEGIN OF mty_ode_smpl.
    TYPES belnr  TYPE ztax_ddl_i_brf_payments-belnr.
    TYPES gjahr  TYPE ztax_ddl_i_brf_payments-gjahr.
    TYPES lifnr  TYPE ztax_ddl_i_brf_payments-lifnr.
    TYPES name2  TYPE ztax_ddl_i_brf_payments-name2.
    TYPES name1  TYPE ztax_ddl_i_brf_payments-name1.
    TYPES adres  TYPE ztax_ddl_i_brf_payments-adres.
    TYPES tckn   TYPE ztax_ddl_i_brf_payments-tckn.
    TYPES vkn    TYPE ztax_ddl_i_brf_payments-vkn.
    TYPES mindk  TYPE ztax_ddl_i_brf_payments-mindk.
    TYPES mtext  TYPE ztax_ddl_i_brf_payments-mtext.
    TYPES budat  TYPE ztax_ddl_i_brf_payments-budat.
    TYPES xblnr  TYPE ztax_ddl_i_brf_payments-xblnr.
    TYPES beltr  TYPE ztax_ddl_i_brf_payments-beltr.
    TYPES beltrx TYPE ztax_ddl_i_brf_payments-beltrx.
    TYPES gyst   TYPE ztax_ddl_i_brf_payments-gyst.
    TYPES kst    TYPE ztax_ddl_i_brf_payments-kst.
    TYPES sosg   TYPE ztax_ddl_i_brf_payments-sosg.
*    TYPES row_color TYPE /itetr/tax_s_muh_ode-row_color.
    TYPES END OF mty_ode_smpl.
    DATA mt_ode         TYPE mtty_ode.

    TYPES BEGIN OF mty_data_191.
    TYPES rbukrs      TYPE bukrs.
    TYPES gjahr       TYPE gjahr.
    TYPES belnr       TYPE belnr_d.
    TYPES docln       TYPE c LENGTH 6.
    TYPES ryear       TYPE n LENGTH 4.
    TYPES fiscyearper TYPE n LENGTH 7.
    TYPES hsl         TYPE i_glaccountlineitemrawdata-AmountInCompanyCodeCurrency. "hsl.
    TYPES wsl         TYPE i_glaccountlineitemrawdata-AmountInTransactionCurrency. "wsl.
    TYPES drcrk       TYPE c LENGTH 1.         "Debit/Credit Indicator
    TYPES awref_rev   TYPE c LENGTH 12.        "Reversal Reference
    TYPES aworg_rev   TYPE c LENGTH 4.         "Reversal Organization Key
    TYPES awtyp       TYPE c LENGTH 4.         "Document Type
    TYPES awref       TYPE c LENGTH 12.        "Document Reference
    TYPES aworg       TYPE c LENGTH 4.         "Organization Key
    TYPES xreversing  TYPE abap_bool.          "Reversing Indicator
    TYPES xreversed   TYPE abap_bool.          "Reversed Indicator
    TYPES lifnr       TYPE lifnr.              "Vendor Account Number
    TYPES racct       TYPE c LENGTH 10. .            "General Ledger Account
    TYPES sgtxt       TYPE sgtxt.              "Document Item Text
    TYPES rwcur       TYPE waers.              "Currency Key
    TYPES zuonr       TYPE c LENGTH 18.              "Assignment Number
    TYPES budat       TYPE datum.               "Posting Date
    TYPES koart       TYPE c LENGTH 1.         "Account Type
    TYPES END OF mty_data_191.
    "

    TYPES mtty_mg      TYPE TABLE OF mty_mg.
    TYPES mtty_lfb1    TYPE TABLE OF mty_lfb1.
    TYPES mtty_data    TYPE TABLE OF mty_data.
    TYPES mtty_data_191 TYPE TABLE OF mty_data_191.



    DATA mr_monat TYPE RANGE OF monat.

    CONSTANTS BEGIN OF mc_range_att.
    CONSTANTS sign   TYPE c LENGTH 4 VALUE 'SIGN'.
    CONSTANTS option TYPE c LENGTH 6 VALUE 'OPTION'.
    CONSTANTS low    TYPE c LENGTH 3 VALUE 'LOW'.
    CONSTANTS high   TYPE c LENGTH 4 VALUE 'HIGH'.
    CONSTANTS END OF mc_range_att.

    METHODS:

      get_payments IMPORTING iv_bukrs  TYPE bukrs OPTIONAL
                             iv_gjahr  TYPE gjahr OPTIONAL
                             iv_monat  TYPE monat OPTIONAL
                             iv_donemb TYPE ztax_e_donemb OPTIONAL
                             iv_beyant TYPE ztax_e_beyant OPTIONAL
                   EXPORTING et_ode    TYPE mtty_ode,

      get_item_data EXPORTING et_mg       TYPE mtty_mg
                              et_data     TYPE mtty_data
                              et_data_191 TYPE mtty_data_191
                              et_lfb1     TYPE mtty_lfb1,

      fill_period IMPORTING ir_monat       TYPE ANY TABLE
                  EXPORTING er_fiscyearper TYPE ANY TABLE,

      fill_range IMPORTING iv_sign   TYPE string  DEFAULT 'I'
                           iv_option TYPE string DEFAULT 'EQ'
                           iv_low    TYPE clike DEFAULT space
                           iv_high   TYPE clike DEFAULT space
                 EXPORTING et_range  TYPE STANDARD TABLE.

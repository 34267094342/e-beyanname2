unmanaged implementation in class zbp_tax_ddl_i_vat2_kes_report unique;
//strict ( 1 );

define behavior for ZTAX_DDL_I_VAT2_KES_REPORT
lock master
authorization master ( instance )
{
  //  create;
  //  update;
  //  delete;
  field ( readonly ) bukrs, gjahr, monat;

  static action DeleteRecord parameter ZTAX_DDL_I_VAT2_MANUAL_REC_DEL result [1] $self;
  static action AddRecord parameter ZTAX_DDL_I_VAT2_MANUAL_REC_ADD result [1] $self;
  static action UpdateRecord parameter ZTAX_DDL_I_VAT2_MANUAL_REC_ADD result [1] $self;
  action ( features : instance ) CreateXml result [1] $self;


}
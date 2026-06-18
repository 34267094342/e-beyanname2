managed implementation in class zbp_tax_ddl_i_vat1_wthldng_rat unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT1_WTHLDNG_RATE //alias <alias_name>
persistent table ztax_t_voran
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly :update ) CompanyCode, VatIndicator;

  mapping for ztax_t_voran{
  CompanyCode  = bukrs;
  VatIndicator = mwskz;
  Ratio        = oran;
  tevkifat     = tevkifat;
  }
}
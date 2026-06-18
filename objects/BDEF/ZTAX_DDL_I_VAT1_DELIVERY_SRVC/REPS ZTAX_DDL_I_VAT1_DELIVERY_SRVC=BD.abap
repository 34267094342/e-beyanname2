managed implementation in class zbp_tax_ddl_i_vat1_delivery_sr unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT1_DELIVERY_SRVC //alias <alias_name>
persistent table ztax_t_thlog
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly: update ) CompanyCode, FiscalYear, FiscalMonth;
  mapping for ztax_t_thlog{
  CompanyCode = bukrs;
  FiscalYear  = gjahr;
  FiscalMonth = monat;
  Amount      = wrbtr;
  Unit        = waers;
  }
}
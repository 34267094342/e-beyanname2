managed implementation in class zbp_tax_ddl_i_vat2_proc_type unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT2_PROC_TYPE //alias <alias_name>
persistent table ztax_t_k2ist
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) K2type , TaxCode;

  mapping for ztax_t_k2ist{

  K2type = k2type ;
  TaxCode = mwskz;
  }
}
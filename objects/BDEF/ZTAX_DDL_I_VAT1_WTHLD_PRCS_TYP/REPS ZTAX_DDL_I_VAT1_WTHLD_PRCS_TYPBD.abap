managed implementation in class zbp_tax_ddl_i_vat1_wthld_prcs_ unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT1_WTHLD_PRCS_TYP //alias <alias_name>
persistent table ztax_t_tevit
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly :update ) Fieldname;

  mapping for ztax_t_tevit{
  Fieldname = fieldname;
  }
}
managed implementation in class zbp_tax_ddl_i_vat2_calc_rule unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT2_CALC_RULE //alias <alias_name>
persistent table ztax_t_k2hes
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Hesaptip;
}
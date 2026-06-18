managed implementation in class zbp_tax_ddl_i_vat1_k1mt unique;
strict ( 1 );

define behavior for ZTAX_DDL_I_VAT1_K1MT //alias <alias_name>
persistent table ztax_t_k1mt
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Bukrs, Gjahr, Monat, Kiril1, Kiril2, Mwskz;
}
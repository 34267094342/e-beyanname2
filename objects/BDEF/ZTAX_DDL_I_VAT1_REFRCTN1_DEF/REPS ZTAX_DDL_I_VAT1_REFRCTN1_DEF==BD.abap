managed implementation in class zbp_tax_ddl_i_vat1_refrctn1_de unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT1_REFRCTN1_DEF //alias <alias_name>
persistent table ztax_t_k1k1
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly: update ) Refrection1;

  mapping for ztax_t_k1k1{
  Refrection1 = kiril1;
  Explanation = acklm;
  }
}
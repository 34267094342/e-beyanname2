managed implementation in class zbp_tax_ddl_i_vat1_condition_t unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT1_CONDITION_TYPE //alias <alias_name>
persistent table ztax_t_kostr
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly :update ) CompanyCode, Refrection2;

  mapping for ztax_t_kostr{
  CompanyCode   = bukrs;
  Refrection2   = kiril2;
  ConditionType = kosult;
  }
}
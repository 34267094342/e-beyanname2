managed implementation in class zbp_tax_ddl_i_brf_refrctn2_def unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_BRF_REFRCTN2_DEF //alias <alias_name>
persistent table ztax_t_mk2
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Refrection2;
  mapping for ztax_t_mk2
    {
      Refrection2 = kiril2;
      Explanation = acklm;
    }
}
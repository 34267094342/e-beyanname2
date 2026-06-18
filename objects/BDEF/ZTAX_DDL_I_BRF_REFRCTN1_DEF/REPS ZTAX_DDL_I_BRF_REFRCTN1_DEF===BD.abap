managed implementation in class zbp_tax_ddl_i_brf_refrctn1_def unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_BRF_REFRCTN1_DEF //alias <alias_name>
persistent table ztax_t_mk1
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Refrection1;

  mapping for ztax_t_mk1
    {
      Refrection1 = kiril1;
      Explanation = acklm;
    }
}
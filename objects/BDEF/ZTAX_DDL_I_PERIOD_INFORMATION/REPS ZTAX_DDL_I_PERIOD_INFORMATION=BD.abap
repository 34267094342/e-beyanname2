managed implementation in class zbp_tax_ddl_i_period_info unique;
strict ( 2 );

define behavior for Ztax_DDL_I_PERIOD_INFORMATION //alias <alias_name>
persistent table ztax_t_beydb
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode, BeyanType;

  mapping for ztax_t_beydb
    {
      CompanyCode = bukrs;
      BeyanType   = beyant;
      PeriodInfo  = donemb;
    }
}
managed implementation in class zbp_tax_ddl_i_brf_trade_regist unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_BRF_TRADE_REGISTRY //alias <alias_name>
persistent table ztax_t_tscm
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly: update ) TradeRegistry;

  mapping for ztax_t_tscm{
  TradeRegistry = tscm;
  Explanation   = acklm;
  }
}
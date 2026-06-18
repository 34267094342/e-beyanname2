managed implementation in class zbp_tax_ddl_i_brf_seller_def unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_BRF_SELLER_DEF //alias <alias_name>
persistent table ztax_t_mindk
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode, Seller, MinorityIndicator;

  mapping for ztax_t_mindk
    {
      CompanyCode       = bukrs;
      Seller            = lifnr;
      MinorityIndicator = mindk;
    }
}
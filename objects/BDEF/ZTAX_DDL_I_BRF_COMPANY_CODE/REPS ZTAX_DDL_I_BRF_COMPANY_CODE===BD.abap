managed implementation in class zbp_tax_ddl_i_brf_company_code unique;
//strict ( 1 );

define behavior for ZTAX_DDL_I_BRF_COMPANY_CODE //alias <alias_name>
persistent table ztax_t_ms
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly: update ) CompanyCode;
//  association _Header { create; }

  mapping for ztax_t_ms{
  CompanyCode = bukrs;
  }
}

define behavior for ZTAX_DDL_I_BRF_HEADER //alias <alias_name>
persistent table ztax_t_mk1s
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//etag master <field_name>
{
  update;
  delete;
  field ( readonly: update ) CompanyCode, Refrection1;
  association _CompanyCodes;
  association _SubHead { create; }

  mapping for ztax_t_mk1s{
  CompanyCode = bukrs;
  Refrection1 = kiril1;
  Xmlsr       = xmlsr;
  }
}

define behavior for ZTAX_DDL_I_BRF_SUBHEAD //alias <alias_name>
persistent table ztax_t_mk2s
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//etag master <field_name>
{
  update;
  delete;
  field ( readonly: update ) CompanyCode, Refrection1, Refrection2;
  association _Header;
  association _Node { create; }
  association _CompanyCodes;

  mapping for ztax_t_mk2s
  {
  CompanyCode = bukrs;
  Refrection1 = kiril1;
  Refrection2 = kiril2;
  }
}

define behavior for ZTAX_DDL_I_BRF_NODE //alias <alias_name>
persistent table ztax_t_mg
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//etag master <field_name>
{
  update;
  delete;
  field ( readonly: update ) CompanyCode, Refrection1, Refrection2, GLAccount, MinorityIndicator ;
  association _SubHead ;
  association _CompanyCodes;

  mapping for ztax_t_mg{
  CompanyCode = bukrs;
  Refrection1 = kiril1;
  Refrection2 = kiril2;
  GLAccount   = hkont;
  MinorityIndicator = mindk;

  }
}
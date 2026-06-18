managed implementation in class zbp_tax_ddl_i_vat2_company_cod unique;
//strict ( 1 );

define behavior for ZTAX_DDL_I_VAT2_COMPANY_CODES //alias <alias_name>
persistent table ztax_t_k2s
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode;
  //  association _Header { create; }

  mapping for ztax_t_k2s
    {
      CompanyCode = bukrs;
      CompanyName = CompanyName;
    }
}

define behavior for ZTAX_DDL_I_VAT2_HEADER //alias _Header
persistent table ztax_t_k2k1s
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//etag master <field_name>
{
  update;
  delete;
  field ( readonly : update ) CompanyCode, Refrection1;
  association _CompanyCodes;
  association _SubHead { create; }



  mapping for ztax_t_k2k1s
    {
      CompanyCode = bukrs;
      Refrection1 = kiril1;
      xml         = xmlsr;
    }
}

define behavior for ZTAX_DDL_I_VAT2_SUBHEAD //alias <alias_name>
persistent table ztax_t_k2k2s
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//etag master <field_name>
{
  update;
  delete;
  field ( readonly : update ) CompanyCode, Refrection1, Refrection2;
  association _Header;
  association _Node { create; }
  association _CompanyCodes;

  mapping for ztax_t_k2k2s
    {
      CompanyCode = bukrs;
      Refrection1 = kiril1;
      Refrection2 = kiril2;
      Rules       = kural;
    }


}

define behavior for ZTAX_DDL_I_VAT2_NODE //alias <alias_name>
persistent table ztax_t_kdv2g
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//etag master <field_name>
{
  update;
  delete;
  field ( readonly : update) CompanyCode, Refrection1, Refrection2, TaxCode;
  association _SubHead;
  association _CompanyCodes;

  mapping for ztax_t_kdv2g
    {
      CompanyCode = bukrs;
      Refrection1 = kiril1;
      Refrection2 = kiril2;
      TaxCode     = mwskz;
    }


}
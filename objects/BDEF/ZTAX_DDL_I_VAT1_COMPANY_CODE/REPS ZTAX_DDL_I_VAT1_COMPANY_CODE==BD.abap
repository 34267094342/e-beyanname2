managed implementation in class zbp_tax_ddl_i_vat1_company_cod unique;
//strict ;

define behavior for ZTAX_DDL_I_VAT1_COMPANY_CODE //alias <alias_name>
persistent table ztax_t_k1s
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode;
  //  association _Header { create; }

  mapping for ztax_t_k1s
    {
      CompanyCode = bukrs;
    }
}

define behavior for ZTAX_DDL_I_VAT1_HEADER //alias <alias_name>
persistent table ztax_t_k1k1s
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//etag master <field_name>
{
  update;
  delete;
  field ( readonly : update ) CompanyCode, Refrection1;
  association _CompanyCodes;
  association _SubHead { create; }

  mapping for ztax_t_k1k1s
    {
      CompanyCode = bukrs;
      Refrection1 = kiril1;
      Xmlsr       = xmlsr;
    }
}

define behavior for ZTAX_DDL_I_VAT1_SUBHEAD //alias <alias_name>
persistent table ztax_t_k1k2s
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//lock dependent by <no_to_master_association found>
//authorization dependent by <no_to_master_association found>
//etag master <field_name>
{
  update;
  delete;
  field ( readonly : update ) CompanyCode, Refrection1, Refrection2;
  association _Header;
  association _Node { create; }
  association _CompanyCodes;

  mapping for ztax_t_k1k2s
    {
      CompanyCode = bukrs;
      Refrection1 = kiril1;
      Refrection2 = kiril2;
      Rules       = kural;
    }
}

define behavior for ZTAX_DDL_I_VAT1_NODE //alias <alias_name>
persistent table ztax_t_kdv1g
lock dependent by _CompanyCodes
authorization dependent by _CompanyCodes
//lock dependent by <no_to_master_association found>
//authorization dependent by <no_to_master_association found>
//etag master <field_name>
{
  update;
  delete;
  field ( readonly : update ) CompanyCode, Refrection1, Refrection2, TaxCode, GLAccountNumber,blart;
  association _SubHead;
  association _CompanyCodes;

  mapping for ztax_t_kdv1g
    {
      CompanyCode     = bukrs;
      Refrection1     = kiril1;
      Refrection2     = kiril2;
      TaxCode         = mwskz;
      GLAccountNumber = saknr;
      TotalArea       = topal;
      TotalAreaRules  = topalk;
      DCIndicator     = shkzg;
      blart           = blart;
      islem_tur       = islem_tur;
      odeme_tur       = odeme_tur;

    }
}
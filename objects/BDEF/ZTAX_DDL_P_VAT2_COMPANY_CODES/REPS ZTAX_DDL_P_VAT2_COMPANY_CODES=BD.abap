projection;
//strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ZTAX_DDL_P_VAT2_COMPANY_CODES //alias <alias_name>
{
  use create;
  use update;
  use delete;

  use association _Header { create; }
}

define behavior for ZTAX_DDL_P_VAT2_HEADER //alias <alias_name>
{
  use update;
  use delete;

  use association _CompanyCodes;
  use association _SubHead { create; }
}

define behavior for ZTAX_DDL_P_VAT2_SUBHEAD //alias <alias_name>
{
  use update;
  use delete;

  use association _Header;
  use association _Node { create; }
  use association _CompanyCodes;
}

define behavior for ZTAX_DDL_P_VAT2_NODE //alias <alias_name>
{
  use update;
  use delete;

  use association _SubHead;
  use association _CompanyCodes;
}
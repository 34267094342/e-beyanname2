managed implementation in class zbp_tax_ddl_i_file_path unique;
strict ( 2 );

define behavior for ztax_ddl_i_file_path //alias <alias_name>
persistent table ztax_t_beydy
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode, BeyanType;

  mapping for ztax_t_beydy
    {
      CompanyCode = bukrs;
      BeyanType   = beyant;
      FilePath    = dyolu;
    }
}
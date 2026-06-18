managed implementation in class zbp_tax_ddl_i_gib_beyan unique;
strict ( 2 );

define behavior for ztax_ddl_i_gib_beyan //alias <alias_name>
persistent table ztax_t_gib
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode, BeyanType, Fieldname;


  mapping for ztax_t_gib{
  CompanyCode = bukrs;
  BeyanType   = beyant;
  Fieldname   = fieldname_;
  Alan        = alan;
  }

}
managed implementation in class zbp_tax_ddl_i_version unique;
strict ( 2 );

define behavior for ztax_ddl_i_version //alias <alias_name>
persistent table ztax_t_beyv
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) BeyanType;


  mapping for ztax_t_beyv{
  BeyanType = beyant ;
  BeyanVersion =beyanv;
  }

}
managed implementation in class zbp_tax_ddl_i_taxcond unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_TAXCOND //alias <alias_name>
persistent table ztax_t_taxcond
lock master
authorization master ( instance )
//etag master <field_name>
{
  create ( authorization : global );
  update;
  delete;
  field ( readonly : update ) bukrs, kschl;

  mapping for ztax_t_taxcond
    {
      bukrs   = bukrs;
      kbetr   = kbetr;
      kschl   = kschl;
      waers   = waers;
    }

}
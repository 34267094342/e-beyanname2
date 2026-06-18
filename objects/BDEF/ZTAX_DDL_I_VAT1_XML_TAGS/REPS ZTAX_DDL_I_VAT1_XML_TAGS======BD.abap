managed implementation in class zbp_tax_ddl_i_vat1_xml_tags unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_VAT1_XML_TAGS //alias <alias_name>
persistent table ztax_t_bxmls
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Xmlsr, Lvl;

  mapping for ztax_t_bxmls
    {
      Xmlsr   = xmlsr;
      Lvl     = seviye;
      Xmlexp  = xmlacklm;
    }
}
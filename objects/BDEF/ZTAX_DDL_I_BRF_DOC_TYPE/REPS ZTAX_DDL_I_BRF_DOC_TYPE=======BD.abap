managed implementation in class zbp_tax_ddl_i_brf_doc_type unique;
strict ( 2 );

define behavior for ZTAX_DDL_I_BRF_DOC_TYPE //alias <alias_name>
persistent table ztax_t_modt
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) MinorityIndicator;

  mapping for ztax_t_modt
    {
      MinorityIndicator = mindk;
      DocumentType      = beltr;
      Explanation       = acklm;
    }
}
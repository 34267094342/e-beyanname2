managed implementation in class zbp_tax_ddl_i_vat2_payment_typ unique;
strict ( 2 );

define behavior for ztax_ddl_i_vat2_payment_type //alias <alias_name>
persistent table ztax_t_k2odt
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) PaymentType;

  mapping for ztax_t_k2odt{
  PaymentType = odmtr;
  Explanation = acklm;

  }
}
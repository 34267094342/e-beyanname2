managed implementation in class zbp_tax_ddl_i_vat2_k2mt unique;
strict ( 1 );

define behavior for ztax_ddl_i_vat2_k2mt
  persistent table ztax_t_k2mt
  lock master
  authorization master ( instance )
{


  create;
  update;
  delete;

  field ( readonly : update) bukrs, gjahr, monat, buzei;
}
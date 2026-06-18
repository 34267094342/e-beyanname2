unmanaged implementation in class zbp_tax_ddl_i_vat2_beyan_repor unique;
//strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ztax_ddl_i_vat2_beyan_report //alias <alias_name>
//late numbering
lock master
authorization master ( instance )
//etag master <field_name>
{
//  create;
//  update;
//  delete;
  field ( readonly ) bukrs, gjahr, monat,lineitem;


   action ( features : instance ) CreateXml result [1] $self;
}
unmanaged implementation in class zbp_tax_ddl_i_brf_payments unique;
//strict ( 2 ); //Uncomment this line in order to enable strict mode 2. The strict mode has two variants (strict(1), strict(2)) and is prerequisite to be future proof regarding syntax and to be able to release your BO.

define behavior for ztax_ddl_i_brf_payments //alias <alias_name>
lock master
authorization master ( instance )
{
  //  create;
  //  update;
  //  delete;
  field ( readonly : update ) bukrs;


  static action AddRecord parameter ztax_ddl_i_brf_work_place_pop result [1] $self;
  static action DeleteRecord  parameter ztax_ddl_i_brf_work_place_pop result [1] $self;
  static action UpdateRecord  parameter ztax_ddl_i_brf_work_place_pop result [1] $self;

  }
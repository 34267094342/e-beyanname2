managed implementation in class zbp_tax_ddl_i_company_info unique;
strict ( 2 );

define behavior for ztax_ddl_i_company_info //alias <alias_name>
persistent table ztax_t_beyg
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) CompanyCode;

  mapping for ztax_t_beyg{
  CompanyCode = bukrs ;
    Vdkod = VDKOD;
    Mvkno = Mvkno;
    Mtckn = Mtckn;
    Msoyad = Msoyad;
    Mad = Mad;
    Memail = Memail;
    Malkod = Malkod;
    Mtelno = Mtelno;
    Hsvvkn = Hsvvkn;
    Hsv = Hsv;
    Hsvtckn = Hsvtckn;
    Hsvemail = Hsvemail;
    Hsvakod = Hsvakod;
    Hsvtelno = Hsvtelno;
    Dvkno = Dvkno;
    Dtckn = Dtckn;
    Dsoyad = Dsoyad;
    Dad = Dad;
    Demail = Demail;
    Dalkod = Dalkod;
    Dtelno = Dtelno;
    tsicil = tsicil;

  }

}
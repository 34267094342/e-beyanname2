CLASS lhc_ZTAX_DDL_I_BRF_COMPANY_COD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_brf_company_code RESULT result.

ENDCLASS.

CLASS lhc_ZTAX_DDL_I_BRF_COMPANY_COD IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
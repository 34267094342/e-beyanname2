CLASS lhc_ZTAX_DDL_I_VAT1_WTHLDNG_RA DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_vat1_wthldng_rate RESULT result.

ENDCLASS.

CLASS lhc_ZTAX_DDL_I_VAT1_WTHLDNG_RA IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
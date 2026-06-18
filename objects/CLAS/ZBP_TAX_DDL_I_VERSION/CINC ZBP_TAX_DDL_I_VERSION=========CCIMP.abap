CLASS lhc_ztax_ddl_i_version DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_version RESULT result.

ENDCLASS.

CLASS lhc_ztax_ddl_i_version IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
CLASS lhc_ZTAX_DDL_I_VAT1_CONDITION_ DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_vat1_condition_type RESULT result.

ENDCLASS.

CLASS lhc_ZTAX_DDL_I_VAT1_CONDITION_ IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
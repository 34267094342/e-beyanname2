CLASS lhc_ZTAX_DDL_I_VAT1_DELIVERY_S DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_vat1_delivery_srvc RESULT result.

ENDCLASS.

CLASS lhc_ZTAX_DDL_I_VAT1_DELIVERY_S IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
CLASS lhc_ZTAX_DDL_I_BRF_DOC_TYPE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_brf_doc_type RESULT result.

ENDCLASS.

CLASS lhc_ZTAX_DDL_I_BRF_DOC_TYPE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
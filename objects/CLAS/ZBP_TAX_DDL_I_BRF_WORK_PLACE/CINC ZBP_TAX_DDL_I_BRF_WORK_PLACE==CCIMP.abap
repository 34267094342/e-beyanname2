CLASS lhc_ztax_ddl_i_brf_work_place DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_brf_work_place RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ ztax_ddl_i_brf_work_place RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ztax_ddl_i_brf_work_place.

    METHODS addrecord FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_brf_work_place~addrecord RESULT result.

    METHODS deleterecord FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_brf_work_place~deleterecord RESULT result.

    METHODS updaterecord FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_brf_work_place~updaterecord RESULT result.

ENDCLASS.

CLASS lhc_ztax_ddl_i_brf_work_place IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD addrecord.

    DATA lt_new_entries TYPE TABLE OF ztax_t_isy.
    DATA ls_new_entry TYPE ztax_t_isy.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    CHECK sy-subrc = 0.
    ls_new_entry-bukrs = ls_key-%param-bukrs.
    ls_new_entry-isytr = ls_key-%param-isytr.
    ls_new_entry-isykd = ls_key-%param-isykd.
    ls_new_entry-isyscno = ls_key-%param-isyscno.
    ls_new_entry-tscm = ls_key-%param-tscm.
    ls_new_entry-isyfkd = ls_key-%param-isyfkd.
    ls_new_entry-isyad = ls_key-%param-isyad.
    ls_new_entry-isyadrno = ls_key-%param-isyadrno.
    ls_new_entry-isymlkdr = ls_key-%param-isymlkdr.

    APPEND ls_new_entry TO lt_new_entries.

    TRY.


        MODIFY ztax_t_isy FROM TABLE @lt_new_entries.

*
      CATCH cx_uuid_error.


    ENDTRY.

  ENDMETHOD.

  METHOD deleterecord.

    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    CHECK sy-subrc = 0.

    TRY.

        DELETE FROM ztax_t_isy WHERE bukrs = @ls_key-%param-bukrs
                                    AND isykd = @ls_key-%param-isykd
                                    AND isytr = @ls_key-%param-isytr
                                    AND isyscno = @ls_key-%param-isyscno
                                    AND tscm = @ls_key-%param-tscm.
*
      CATCH cx_uuid_error.

    ENDTRY..

  ENDMETHOD.

  METHOD updaterecord.

    DATA lt_new_entries TYPE TABLE OF ztax_t_isy.
    DATA ls_new_entry TYPE ztax_t_isy.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    CHECK sy-subrc = 0.
    ls_new_entry-bukrs = ls_key-%param-bukrs.
    ls_new_entry-isytr = ls_key-%param-isytr.
    ls_new_entry-isykd = ls_key-%param-isykd.
    ls_new_entry-isyscno = ls_key-%param-isyscno.
    ls_new_entry-tscm = ls_key-%param-tscm.
    ls_new_entry-isyfkd = ls_key-%param-isyfkd.
    ls_new_entry-isyad = ls_key-%param-isyad.
    ls_new_entry-isyadrno = ls_key-%param-isyadrno.
    ls_new_entry-isymlkdr = ls_key-%param-isymlkdr.

    APPEND ls_new_entry TO lt_new_entries.

    TRY.


        MODIFY ztax_t_isy FROM TABLE @lt_new_entries.

*
      CATCH cx_uuid_error.


    ENDTRY.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_ztax_ddl_i_brf_work_place DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ztax_ddl_i_brf_work_place IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
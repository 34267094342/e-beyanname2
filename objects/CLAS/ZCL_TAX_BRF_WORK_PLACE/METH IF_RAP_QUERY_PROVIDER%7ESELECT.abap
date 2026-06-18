  METHOD if_rap_query_provider~select.

    TRY.


        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
        DATA: lt_bukrs_range  TYPE RANGE OF bukrs,
              lt_gjahr_range  TYPE RANGE OF gjahr,
              lt_monat_range  TYPE RANGE OF monat,
              lt_donemb_range TYPE RANGE OF ztax_e_donemb,
              lt_output       TYPE TABLE OF ztax_ddl_i_brf_work_place,
              ls_output       TYPE ztax_ddl_i_brf_work_place.
        DATA(lt_paging) = io_request->get_paging( ).
*
        LOOP AT lt_filter INTO DATA(ls_filter).
          CASE ls_filter-name.
            WHEN 'BUKRS'.
              lt_bukrs_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'GJAHR'.
              lt_gjahr_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'MONAT'.
              lt_monat_range = CORRESPONDING #( ls_filter-range ).
*            WHEN 'DONEMB'.
*              lt_monat_range = CORRESPONDING #( ls_filter-range ).
          ENDCASE.
        ENDLOOP.
*
        p_bukrs  = VALUE #( lt_bukrs_range[ 1 ]-low OPTIONAL ).
        p_gjahr  = VALUE #( lt_gjahr_range[ 1 ]-low OPTIONAL ).
        p_monat  = VALUE #( lt_monat_range[ 1 ]-low OPTIONAL ).
*        p_donemb = VALUE #( lt_donemb_range[ 1 ]-low OPTIONAL ).
        p_donemb = 01.


        FIELD-SYMBOLS <fs_isy> TYPE ztax_ddl_i_brf_work_place.

*    CLEAR mv_mod.
*    CLEAR mt_isy.
*    CLEAR ms_button_pushed.
*    ms_button_pushed-isy = abap_true.

        SELECT ztax_t_isy~bukrs,
               i_companycode~companycodename AS butxt,
               ztax_t_isy~isytr,
               ztax_t_isy~isykd,
               ztax_t_isy~isyscno,
               ztax_t_isy~tscm,
               ztax_t_tscm~acklm,
               ztax_t_isy~isyfkd,
               ztax_t_isy~isyad,
               ztax_t_isy~isyadrno,
               ztax_t_isy~isymlkdr

               FROM ztax_t_isy
               INNER JOIN i_companycode
               ON i_companycode~companycode EQ ztax_t_isy~bukrs
               LEFT OUTER JOIN ztax_t_tscm
               ON ztax_t_tscm~tscm EQ ztax_t_isy~tscm
                  INTO TABLE @DATA(lt_isy).

        LOOP AT lt_isy INTO DATA(ls_isy).
*          APPEND INITIAL LINE TO mt_isy ASSIGNING <fs_isy>.
          CHECK <fs_isy> IS ASSIGNED.
          MOVE-CORRESPONDING ls_isy TO <fs_isy>.
          UNASSIGN <fs_isy>.
        ENDLOOP.



        LOOP AT lt_isy INTO DATA(ls_is) .
          MOVE-CORRESPONDING ls_is TO ls_output.
          APPEND ls_output TO lt_output.
        ENDLOOP.


        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_output ) ).
        ENDIF.
        io_response->set_data( it_data = lt_output ).


      CATCH cx_rap_query_filter_no_range.
    ENDTRY.
  ENDMETHOD.
  METHOD if_rap_query_provider~select.

*    FIELD-SYMBOLS <fs_out_tev>   TYPE STANDARD TABLE.
*    FIELD-SYMBOLS <fs_line>      TYPE any.
    FIELD-SYMBOLS <fs_value>     TYPE any.
    FIELD-SYMBOLS <fs_value_dyn> TYPE any.



    TRY.

        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
        DATA: lt_bukrs_range  TYPE RANGE OF bukrs,
              lt_gjahr_range  TYPE RANGE OF gjahr,
              lt_monat_range  TYPE RANGE OF monat,
              lt_donemb_range TYPE RANGE OF ztax_e_donemb,
              lt_output       TYPE TABLE OF ztax_ddl_i_vat1_tev_report,
              ls_output       TYPE ztax_ddl_i_vat1_tev_report.
        DATA(lt_paging) = io_request->get_paging( ).

        LOOP AT lt_filter INTO DATA(ls_filter).
          CASE ls_filter-name.
            WHEN 'BUKRS'.
              lt_bukrs_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'GJAHR'.
              lt_gjahr_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'MONAT'.
              lt_monat_range = CORRESPONDING #( ls_filter-range ).
            WHEN 'DONEMB'.
              lt_donemb_range = CORRESPONDING #( ls_filter-range ).
          ENDCASE.
        ENDLOOP.

        p_bukrs  = VALUE #( lt_bukrs_range[ 1 ]-low OPTIONAL ).
        p_gjahr  = VALUE #( lt_gjahr_range[ 1 ]-low OPTIONAL ).
        p_monat  = VALUE #( lt_monat_range[ 1 ]-low OPTIONAL ).
        p_donemb = 01."VALUE #( lt_donemb_range[ 1 ]-low OPTIONAL ).

        CALL METHOD get_data
          EXPORTING
            iv_bukrs  = p_bukrs
            iv_gjahr  = p_gjahr
            iv_monat  = p_monat
            iv_donemb = p_donemb
          IMPORTING
            et_result = lt_output.



        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_output ) ).
        ENDIF.
        io_response->set_data( it_data = lt_output ).

      CATCH cx_rap_query_filter_no_range.
    ENDTRY.
  ENDMETHOD.
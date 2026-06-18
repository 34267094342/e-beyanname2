  METHOD if_rap_query_provider~select.

    DATA : lv_lineitem TYPE int1.
    TRY.
        DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).

        DATA: lt_bukrs_range  TYPE RANGE OF bukrs,
              lt_gjahr_range  TYPE RANGE OF gjahr,
              lt_monat_range  TYPE RANGE OF monat,
              lt_donemb_range TYPE RANGE OF ztax_e_donemb,
              lt_output       TYPE TABLE OF ztax_ddl_i_vat1_dec_report,
              ls_output       TYPE ztax_ddl_i_vat1_dec_report.

        DATA(lo_paging) = io_request->get_paging( ).
        DATA(top)       = lo_paging->get_page_size( ).
        DATA(skip)      = lo_paging->get_offset( ).
        IF top < 0.
          top = 1.
        ENDIF.

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

        p_bukrs  = VALUE #( lt_bukrs_range[ 1 ]-low OPTIONAL ).
        p_gjahr  = VALUE #( lt_gjahr_range[ 1 ]-low OPTIONAL ).
        p_monat  = VALUE #( lt_monat_range[ 1 ]-low OPTIONAL ).
*        p_donemb = VALUE #( lt_donemb_range[ 1 ]-low OPTIONAL ).
        p_donemb = 01."Sadece aylık kullanıldığı için
        p_beyant = 02.


*        kdv1( ).

        CALL METHOD kdv1
          EXPORTING
            iv_bukrs   = p_bukrs
            iv_gjahr   = p_gjahr
            iv_monat   = p_monat
            iv_donemb  = p_donemb
            iv_beyant  = p_beyant
          IMPORTING
            et_collect = mt_collect
            er_monat   = mr_monat.


        SORT mt_collect BY kiril1 kiril2 kiril3.
        LOOP AT mt_collect INTO DATA(ls_collect).
          lv_lineitem = lv_lineitem + 1.
          IF skip IS NOT INITIAL.
            CHECK sy-tabix > skip.
          ENDIF.
          APPEND INITIAL LINE TO lt_output ASSIGNING FIELD-SYMBOL(<fs_output>).
          MOVE-CORRESPONDING ls_collect TO <fs_output>.
          <fs_output>-bukrs = p_bukrs.
          <fs_output>-gjahr = p_gjahr.
          <fs_output>-monat = p_monat.
          <fs_output>-currency = 'TRY'.
          <fs_output>-lineitem = lv_lineitem.
          IF lines( lt_output ) >= top.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( iv_total_number_of_records = lines( mt_collect ) ).
        ENDIF.
        io_response->set_data( it_data = lt_output ).

      CATCH cx_rap_query_filter_no_range.
    ENDTRY.
  ENDMETHOD.
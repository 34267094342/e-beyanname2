  METHOD fill_amount_fields.

    DATA ls_hesap TYPE mty_hesap.
    DATA ls_parameter TYPE mty_hesap.
    DATA lt_par TYPE abap_parmbind_tab.
    DATA ls_par TYPE abap_parmbind.
    DATA lt_exc TYPE abap_excpbind_tab.
    DATA lo_exc_ref TYPE REF TO cx_sy_dyn_call_error.
    DATA lv_hesaptip   TYPE ztax_t_k2hes-hesaptip.
    DATA lv_result TYPE p LENGTH 16 DECIMALS 2."hwbas.
    DATA lv_method_name(100).

    FIELD-SYMBOLS <fs_value>     TYPE any.

    DO 5 TIMES.
      CLEAR lt_par.
      CLEAR ls_par.
      CLEAR lv_hesaptip.
      lv_hesaptip = sy-index.

      LOOP AT it_hesap INTO ls_hesap WHERE hesaptip EQ lv_hesaptip.

        CLEAR ls_parameter.
        READ TABLE it_parameters INTO ls_parameter WITH KEY kschl = ls_hesap-kschl BINARY SEARCH.
        CHECK sy-subrc IS INITIAL.
        CONCATENATE 'IV_' ls_hesap-kschl INTO ls_par-name.
        ls_par-kind = cl_abap_objectdescr=>exporting.

        CASE ls_hesap-hesaptip.
          WHEN '001'.
            CREATE DATA ls_par-value LIKE ls_parameter-amount.
            ASSIGN ls_par-value->* TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              <fs_value> = ls_parameter-amount.
              UNASSIGN <fs_value>.
            ENDIF.
          WHEN '002'.
            CREATE DATA ls_par-value LIKE ls_parameter-percent.
            ASSIGN ls_par-value->* TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              <fs_value> = ls_parameter-percent.
              UNASSIGN <fs_value>.
            ENDIF.
          WHEN '003'.
            CREATE DATA ls_par-value LIKE ls_parameter-percent.
            ASSIGN ls_par-value->* TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              <fs_value> = ls_parameter-percent.
              UNASSIGN <fs_value>.
            ENDIF.
          WHEN '004'.
            CREATE DATA ls_par-value LIKE ls_parameter-tax.
            ASSIGN ls_par-value->* TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              <fs_value> = ls_parameter-tax.
              UNASSIGN <fs_value>.
            ENDIF.
          WHEN '005'.
            CREATE DATA ls_par-value LIKE ls_parameter-tax.
            ASSIGN ls_par-value->* TO <fs_value>.
            IF <fs_value> IS ASSIGNED.
              <fs_value> = ls_parameter-tax.
              UNASSIGN <fs_value>.
            ENDIF.
        ENDCASE.

        INSERT ls_par INTO TABLE lt_par.
        CLEAR ls_par.

      ENDLOOP.
      CHECK sy-subrc IS INITIAL.


*      CLEAR lv_result.
*      ls_par-name = 'EV'.
*      ls_par-kind = cl_abap_objectdescr=>importing.
*      GET REFERENCE OF  lv_result INTO ls_par-value.
*      INSERT ls_par INTO TABLE lt_par.
*      CLEAR ls_par.
      CLEAR lv_result.
      ls_par-name = 'EV'.
      ls_par-kind = cl_abap_objectdescr=>importing.
      ls_par-value = REF #( lv_result ).  " Yeni REF operatörü
      INSERT ls_par INTO TABLE lt_par.
      CLEAR ls_par.

      CLEAR lv_method_name.
      CONCATENATE 'M'
                  lv_hesaptip
                  INTO lv_method_name.

*      TRY.
*
*          CALL METHOD (lcl_tax=>mv_prog)=>(lv_method_name)
*            PARAMETER-TABLE
*            lt_par
*            EXCEPTION-TABLE
*            lt_exc.
*
*        CATCH cx_sy_dyn_call_error INTO lo_exc_ref.
*          MESSAGE lo_exc_ref->get_text( ) TYPE 'I'.
*          LEAVE PROGRAM.
*      ENDTRY.

      FIELD-SYMBOLS <fs_mws> TYPE any.
      FIELD-SYMBOLS <fs_ztra> TYPE any.

      READ TABLE lt_par INTO DATA(ls_parr) WITH KEY name = 'IV_MWVS'.
      IF sy-subrc = 0 AND ls_parr-value IS BOUND.
        ASSIGN ls_parr-value->* TO <fs_mws>.
      ENDIF.
      READ TABLE lt_par INTO ls_parr WITH KEY name = 'IV_ZTRA'.
      IF sy-subrc = 0 AND ls_parr-value IS BOUND.
        ASSIGN ls_parr-value->* TO <fs_ztra>.
      ENDIF.

      CASE lv_hesaptip.
        WHEN '001'.
          IF <fs_mws> IS ASSIGNED.
            lv_result =  <fs_mws>.
          ENDIF.
        WHEN '002'.
          IF <fs_mws>  IS ASSIGNED.
            lv_result =  <fs_mws> / 10.
          ENDIF.
        WHEN '003'.
          IF <fs_mws>  IS ASSIGNED AND <fs_mws>  IS ASSIGNED.
            lv_result = ( <fs_ztra> / <fs_mws> )  * 10.
          ENDIF.
        WHEN '004'.
          IF <fs_mws> IS ASSIGNED.
            lv_result =  <fs_mws>.
          ENDIF.
        WHEN '005'.
          IF <fs_ztra>  IS ASSIGNED.
            lv_result =  <fs_ztra>.
          ENDIF.

      ENDCASE.


      CASE lv_hesaptip.
        WHEN '001'.
          cs_collect-matrah    = lv_result.
        WHEN '002'.
          cs_collect-oran      = lv_result.
        WHEN '003'.
          cs_collect-tevkifato = lv_result.
        WHEN '004'.
          cs_collect-vergi     = lv_result.
        WHEN '005'.
          cs_collect-tevkifat  = lv_result.
      ENDCASE.

    ENDDO.

  ENDMETHOD.
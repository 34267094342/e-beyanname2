  METHOD fill_shared_structure.
    DATA ls_read_tab  TYPE mty_read_tab.
    CLEAR mt_hesap.
    CLEAR mt_map.
    CLEAR mr_kschl.
    CLEAR mr_mwskz.

    me->get_map_tab( IMPORTING et_map = mt_map ).
    me->fill_mwskz_range( EXPORTING it_map   = mt_map
                          IMPORTING er_mwskz = mr_mwskz ).
    me->change_formul_for_abap( IMPORTING et_hesap = mt_hesap ).

    me->fill_kschl_range( EXPORTING it_hesap = mt_hesap
                          IMPORTING er_kschl = mr_kschl ).

*    IF me->mv_prog IS INITIAL AND me IS BOUND.
*
*      me->dyn_prog( EXPORTING it_hesap = mt_hesap
*                    IMPORTING ev_prog  = lcl_tax=>mv_prog ).
*    ENDIF.
    CLEAR ls_read_tab.
    ls_read_tab-bset = abap_true.
    ls_read_tab-bseg = abap_true.

    me->find_document( EXPORTING is_read_tab = ls_read_tab
                             ir_mwskz    = mr_mwskz
                             ir_kschl    = mr_kschl
                   IMPORTING et_bkpf     = mt_bkpf
                             et_bset     = mt_bset
                             et_bseg     = mt_bseg ).



  ENDMETHOD.
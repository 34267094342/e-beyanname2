  METHOD get_data.

    IF iv_bukrs IS NOT INITIAL.
      p_bukrs = iv_bukrs.
    ENDIF.

    IF iv_gjahr IS NOT INITIAL.
      p_gjahr = iv_gjahr.
    ENDIF.


    IF iv_monat IS NOT INITIAL.
      p_monat = iv_monat.
    ENDIF.

    fill_monat_range( ).
    fill_shared_structure( ).
    kesinti( ).

    et_result = mt_kesinti.

  ENDMETHOD.
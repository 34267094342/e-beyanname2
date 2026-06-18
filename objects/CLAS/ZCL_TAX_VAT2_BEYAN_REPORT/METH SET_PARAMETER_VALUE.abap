  METHOD set_parameter_value.

    FIELD-SYMBOLS <fs_parameter> TYPE mty_hesap.
    DATA ls_kschl_mwskz TYPE mty_kschl_mwskz.

    LOOP AT ct_parameters ASSIGNING <fs_parameter>.
      CLEAR <fs_parameter>-amount.
      CLEAR <fs_parameter>-tax.
      CLEAR <fs_parameter>-percent.
      LOOP AT it_kschl_mwskz INTO ls_kschl_mwskz WHERE kiril1 = iv_kiril1
                                                   AND kiril2 = iv_kiril2
                                                   AND mwskz  = iv_mwskz
                                                   AND kschl  = <fs_parameter>-kschl.
*        ADD ls_kschl_mwskz-hwbas TO <fs_parameter>-amount.
        <fs_parameter>-amount = <fs_parameter>-amount + ls_kschl_mwskz-hwbas .
*        ADD ls_kschl_mwskz-hwste TO <fs_parameter>-tax.
        <fs_parameter>-tax = <fs_parameter>-tax + ls_kschl_mwskz-hwste.
        <fs_parameter>-percent = abs( ls_kschl_mwskz-kbetr ).
      ENDLOOP.
    ENDLOOP.



  ENDMETHOD.
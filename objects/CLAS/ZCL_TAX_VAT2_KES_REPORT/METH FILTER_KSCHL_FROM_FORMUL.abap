  METHOD filter_kschl_from_formul.
    DELETE ct_hesap WHERE kschl EQ space OR kschl NA mc_kschl_character.
  ENDMETHOD.
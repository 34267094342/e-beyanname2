  METHOD get_gib.

    SELECT fieldname_ AS fieldname,
           alan
      FROM ztax_t_gib
     WHERE bukrs  EQ @p_bukrs
       AND beyant EQ @p_beyant
      INTO TABLE @et_gib.

  ENDMETHOD.
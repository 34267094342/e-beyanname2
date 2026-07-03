  METHOD get_condition_type .

    SELECT bukrs  ,
           kiril2 ,
           kosult
           FROM ztax_t_kostr
           WHERE bukrs EQ @p_bukrs
      INTO TABLE @et_kostr.

  ENDMETHOD.
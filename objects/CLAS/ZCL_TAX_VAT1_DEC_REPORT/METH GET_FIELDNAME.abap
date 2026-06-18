  METHOD get_fieldname.

    CLEAR et_tevita.
    SELECT fieldname
      FROM ztax_t_tevit
      INTO TABLE @et_tevita.

  ENDMETHOD.
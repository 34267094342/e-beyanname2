  METHOD get_map_tab.

    SELECT ztax_t_kdv2g~kiril1,
           ztax_t_k2k1s~xmlsr,
           ztax_t_kdv2g~kiril2,
           ztax_t_kdv2g~mwskz,
           ztax_t_k2k2s~kural,
           ztax_t_k2k1~acklm  AS acklm1,
           ztax_t_k2k2~acklm  AS acklm2
           FROM ztax_t_kdv2g
           INNER JOIN ztax_t_k2s
           ON ztax_t_k2s~bukrs EQ ztax_t_kdv2g~bukrs
           INNER JOIN ztax_t_k2k1s
           ON ztax_t_k2k1s~bukrs EQ ztax_t_kdv2g~bukrs
           AND ztax_t_k2k1s~kiril1 EQ ztax_t_kdv2g~kiril1
           INNER JOIN ztax_t_k2k2s
           ON ztax_t_k2k2s~bukrs EQ ztax_t_kdv2g~bukrs
           AND ztax_t_k2k2s~kiril1 EQ ztax_t_kdv2g~kiril1
           AND ztax_t_k2k2s~kiril2 EQ ztax_t_kdv2g~kiril2
           INNER JOIN ztax_t_k2k1
           ON ztax_t_k2k1~kiril1 EQ ztax_t_kdv2g~kiril1
           INNER JOIN ztax_t_k2k2
           ON ztax_t_k2k2~kiril2 EQ ztax_t_kdv2g~kiril2
           WHERE ztax_t_kdv2g~bukrs EQ @p_bukrs
           INTO TABLE @et_map.

  ENDMETHOD.
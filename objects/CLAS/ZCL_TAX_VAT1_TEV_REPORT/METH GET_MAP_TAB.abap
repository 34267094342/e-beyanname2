  METHOD get_map_tab.


    SELECT ztax_t_kdv1g~kiril1,
           ztax_t_k1k1s~xmlsr,
           ztax_t_kdv1g~kiril2,
           ztax_t_kdv1g~mwskz,
           ztax_t_kdv1g~saknr,
           ztax_t_kdv1g~topal,
           ztax_t_kdv1g~topalk,
           ztax_t_kdv1g~shkzg,
           ztax_t_k1k2s~kural,
           ztax_t_k1k1~acklm  AS acklm1,
           ztax_t_k1k2~acklm  AS acklm2
           FROM ztax_t_kdv1g
           INNER JOIN ztax_t_k1s
            ON ztax_t_k1s~bukrs EQ ztax_t_kdv1g~bukrs
           INNER JOIN ztax_t_k1k1s
            ON ztax_t_k1k1s~bukrs  EQ ztax_t_kdv1g~bukrs
           AND ztax_t_k1k1s~kiril1 EQ ztax_t_kdv1g~kiril1
           INNER JOIN ztax_t_k1k2s
            ON ztax_t_k1k2s~bukrs  EQ ztax_t_kdv1g~bukrs
           AND ztax_t_k1k2s~kiril1 EQ ztax_t_kdv1g~kiril1
           AND ztax_t_k1k2s~kiril2 EQ ztax_t_kdv1g~kiril2
           INNER JOIN ztax_t_k1k1
           ON ztax_t_k1k1~kiril1 EQ ztax_t_kdv1g~kiril1
           INNER JOIN ztax_t_k1k2
           ON ztax_t_k1k2~kiril2 EQ ztax_t_kdv1g~kiril2
           WHERE ztax_t_kdv1g~bukrs EQ @p_bukrs
           INTO TABLE @et_map.

  ENDMETHOD.
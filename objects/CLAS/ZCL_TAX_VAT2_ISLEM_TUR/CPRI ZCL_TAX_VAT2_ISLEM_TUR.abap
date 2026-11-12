  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_result,
        bukrs     TYPE bukrs,
        belnr     TYPE belnr_d,
        gjahr     TYPE gjahr,
        mwskz     TYPE mwskz,
        buzei     TYPE n LENGTH 6,
        islem_tur TYPE ty_islem_tur,
        source    TYPE ty_source,
      END OF ty_result .
    TYPES tt_distinct TYPE SORTED TABLE OF ty_islem_tur WITH UNIQUE KEY table_line .

    DATA mt_item    TYPE SORTED TABLE OF ty_item    WITH NON-UNIQUE KEY bukrs belnr gjahr buzei .
    DATA mt_taxitem TYPE SORTED TABLE OF ty_taxitem WITH NON-UNIQUE KEY bukrs belnr gjahr mwskz buzei .
    DATA mt_ist     TYPE SORTED TABLE OF ty_ist     WITH NON-UNIQUE KEY mwskz k2type .
    DATA mt_result  TYPE HASHED TABLE OF ty_result  WITH UNIQUE KEY bukrs belnr gjahr mwskz buzei .

    METHODS check_value
      IMPORTING
        !iv_mwskz     TYPE mwskz
        !iv_value     TYPE clike
      EXPORTING
        !ev_islem_tur TYPE ty_islem_tur
        !ev_valid     TYPE abap_bool .
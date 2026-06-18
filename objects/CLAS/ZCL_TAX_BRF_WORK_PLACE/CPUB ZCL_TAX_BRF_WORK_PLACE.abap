CLASS zcl_tax_brf_work_place DEFINITION
  PUBLIC

  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .


    DATA p_monat TYPE monat.
    DATA p_gjahr TYPE gjahr.
    DATA p_bukrs TYPE bukrs.
    DATA p_donemb TYPE ztax_e_donemb.

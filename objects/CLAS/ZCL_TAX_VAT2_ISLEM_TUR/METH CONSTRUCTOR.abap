  METHOD constructor.

    mt_ist = it_ist.
    DELETE ADJACENT DUPLICATES FROM mt_ist COMPARING mwskz k2type.

    "Kalemler çağıran tarafta JOIN nedeniyle çoğalmış olabilir; tekilleştir.
    LOOP AT it_item INTO DATA(ls_item).
      READ TABLE mt_item TRANSPORTING NO FIELDS WITH TABLE KEY bukrs = ls_item-bukrs
                                                               belnr = ls_item-belnr
                                                               gjahr = ls_item-gjahr
                                                               buzei = ls_item-buzei.
      IF sy-subrc IS NOT INITIAL.
        INSERT ls_item INTO TABLE mt_item.
      ENDIF.
    ENDLOOP.

    LOOP AT it_taxitem INTO DATA(ls_taxitem).
      READ TABLE mt_taxitem TRANSPORTING NO FIELDS WITH TABLE KEY bukrs = ls_taxitem-bukrs
                                                                  belnr = ls_taxitem-belnr
                                                                  gjahr = ls_taxitem-gjahr
                                                                  mwskz = ls_taxitem-mwskz
                                                                  buzei = ls_taxitem-buzei.
      IF sy-subrc IS NOT INITIAL.
        INSERT ls_taxitem INTO TABLE mt_taxitem.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
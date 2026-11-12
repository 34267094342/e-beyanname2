*"* use this source file for your ABAP unit test classes
CLASS ltc_determine DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_tax_vat2_islem_tur.

    METHODS setup.
    METHODS run
      IMPORTING iv_belnr  TYPE belnr_d
                iv_mwskz  TYPE mwskz
                iv_tax    TYPE clike
                iv_type   TYPE zcl_tax_vat2_islem_tur=>ty_islem_tur OPTIONAL
                iv_source TYPE zcl_tax_vat2_islem_tur=>ty_source.

    METHODS tax_line_assignment      FOR TESTING.
    METHODS expense_line_fallback    FOR TESTING.
    METHODS single_type_of_tax_code  FOR TESTING.
    METHODS ambiguous_is_unresolved  FOR TESTING.
    METHODS other_tax_code_ignored   FOR TESTING.
    METHODS position_in_mixed_doc    FOR TESTING.
    METHODS conflicting_expense_lines FOR TESTING.
ENDCLASS.


CLASS ltc_determine IMPLEMENTATION.

  METHOD setup.

    DATA lt_ist  TYPE zcl_tax_vat2_islem_tur=>tt_ist.
    DATA lt_item TYPE zcl_tax_vat2_islem_tur=>tt_item.
    DATA lt_tax  TYPE zcl_tax_vat2_islem_tur=>tt_taxitem.

    lt_ist = VALUE #( ( k2type = '201' mwskz = 'T3' ) ( k2type = '250' mwskz = 'T3' )
                      ( k2type = '224' mwskz = 'T1' ) ( k2type = '226' mwskz = 'T1' )
                      ( k2type = '250' mwskz = 'T1' )
                      ( k2type = '202' mwskz = 'T6' ) ( k2type = '207' mwskz = 'T6' )
                      ( k2type = '212' mwskz = 'T6' ) ( k2type = '250' mwskz = 'T6' ) ).

    lt_item = VALUE #(
      "Tayin vergi kalemlerinde dolu (KR)
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000001' koart = 'K' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000002' koart = 'S' mwskz = 'T3' value = '201' )
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000003' koart = 'S' buzid = 'T' mwskz = 'T3' value = '201' )
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000004' koart = 'S' buzid = 'T' mwskz = 'T3' value = '201' )
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000005' koart = 'S' buzid = 'T' mwskz = 'T3' value = '201' )
      "JOIN kaynaklı çift kayıt
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000003' koart = 'S' buzid = 'T' mwskz = 'T3' value = '201' )
      "Tayin yalnız gider kaleminde, vergi kalemleri boş / tarih (KR)
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000001' koart = 'K' mwskz = 'T1' )
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000002' koart = 'S' mwskz = 'T1' value = '224' )
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000003' koart = 'S' buzid = 'T' mwskz = 'T1' )
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000004' koart = 'S' buzid = 'T' mwskz = 'T1' )
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000005' koart = 'S' buzid = 'T' mwskz = 'T1' value = '20260926' )
      "MIRO: hiçbir kalemde Tayin yok, T3 tek işlem türüne bağlı
      ( bukrs = '1000' belnr = '5100000003' gjahr = '2026' buzei = '000001' koart = 'K' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '5100000003' gjahr = '2026' buzei = '000002' koart = 'A' buzid = 'S' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '5100000003' gjahr = '2026' buzei = '000003' koart = 'S' buzid = 'T' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '5100000003' gjahr = '2026' buzei = '000004' koart = 'S' buzid = 'T' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '5100000003' gjahr = '2026' buzei = '000005' koart = 'S' buzid = 'T' mwskz = 'T3' value = '20260918' )
      "MIRO: Tayin yok, T6 birden çok işlem türüne bağlı
      ( bukrs = '1000' belnr = '5100000004' gjahr = '2026' buzei = '000001' koart = 'K' mwskz = 'T6' )
      ( bukrs = '1000' belnr = '5100000004' gjahr = '2026' buzei = '000002' koart = 'S' mwskz = 'T6' )
      ( bukrs = '1000' belnr = '5100000004' gjahr = '2026' buzei = '000003' koart = 'S' buzid = 'T' mwskz = 'T6' )
      "Tek belgede iki işlem türü, vergi kalemleri sırayla 207 / 212
      ( bukrs = '1000' belnr = '1900000005' gjahr = '2026' buzei = '000003' koart = 'S' buzid = 'T' mwskz = 'T6' value = '207' )
      ( bukrs = '1000' belnr = '1900000005' gjahr = '2026' buzei = '000004' koart = 'S' buzid = 'T' mwskz = 'T6' value = '212' )
      "Vergi kalemleri boş, gider kalemleri çelişkili
      ( bukrs = '1000' belnr = '1900000006' gjahr = '2026' buzei = '000002' koart = 'S' mwskz = 'T6' value = '207' )
      ( bukrs = '1000' belnr = '1900000006' gjahr = '2026' buzei = '000003' koart = 'S' mwskz = 'T6' value = '212' )
      ( bukrs = '1000' belnr = '1900000006' gjahr = '2026' buzei = '000004' koart = 'S' buzid = 'T' mwskz = 'T6' ) ).

    lt_tax = VALUE #(
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000001' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000002' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '1900000001' gjahr = '2026' buzei = '000003' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000001' mwskz = 'T1' )
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000002' mwskz = 'T1' )
      ( bukrs = '1000' belnr = '1900000002' gjahr = '2026' buzei = '000003' mwskz = 'T1' )
      ( bukrs = '1000' belnr = '5100000003' gjahr = '2026' buzei = '000001' mwskz = 'T3' )
      ( bukrs = '1000' belnr = '5100000004' gjahr = '2026' buzei = '000001' mwskz = 'T6' )
      ( bukrs = '1000' belnr = '1900000005' gjahr = '2026' buzei = '000001' mwskz = 'T6' )
      ( bukrs = '1000' belnr = '1900000005' gjahr = '2026' buzei = '000002' mwskz = 'T6' )
      ( bukrs = '1000' belnr = '1900000006' gjahr = '2026' buzei = '000001' mwskz = 'T6' ) ).

    mo_cut = NEW #( it_item    = lt_item
                    it_taxitem = lt_tax
                    it_ist     = lt_ist ).

  ENDMETHOD.

  METHOD run.

    mo_cut->determine( EXPORTING iv_bukrs     = '1000'
                                 iv_belnr     = iv_belnr
                                 iv_gjahr     = '2026'
                                 iv_mwskz     = iv_mwskz
                                 iv_taxitem   = iv_tax
                       IMPORTING ev_islem_tur = DATA(lv_type)
                                 ev_source    = DATA(lv_source) ).

    cl_abap_unit_assert=>assert_equals( exp = iv_source act = lv_source msg = |Kaynak { iv_belnr }| ).
    IF iv_type IS SUPPLIED.
      cl_abap_unit_assert=>assert_equals( exp = iv_type act = lv_type msg = |İşlem türü { iv_belnr }| ).
    ENDIF.

  ENDMETHOD.

  METHOD tax_line_assignment.
    run( iv_belnr = '1900000001' iv_mwskz = 'T3' iv_tax = '001' iv_type = '201'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_tax_line ).
    run( iv_belnr = '1900000001' iv_mwskz = 'T3' iv_tax = '003' iv_type = '201'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_tax_line ).
  ENDMETHOD.

  METHOD expense_line_fallback.
    run( iv_belnr = '1900000002' iv_mwskz = 'T1' iv_tax = '002' iv_type = '224'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_expense_line ).
    "Tarih içeren Tayin (20260926) işlem türü sayılmamalı
    run( iv_belnr = '1900000002' iv_mwskz = 'T1' iv_tax = '003' iv_type = '224'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_expense_line ).
  ENDMETHOD.

  METHOD single_type_of_tax_code.
    run( iv_belnr = '5100000003' iv_mwskz = 'T3' iv_tax = '001' iv_type = '201'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_tax_code ).
  ENDMETHOD.

  METHOD ambiguous_is_unresolved.
    run( iv_belnr = '5100000004' iv_mwskz = 'T6' iv_tax = '001'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_unresolved ).
  ENDMETHOD.

  METHOD other_tax_code_ignored.
    run( iv_belnr = '1900000001' iv_mwskz = 'V3' iv_tax = '001'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_not_relevant ).
  ENDMETHOD.

  METHOD position_in_mixed_doc.
    run( iv_belnr = '1900000005' iv_mwskz = 'T6' iv_tax = '001' iv_type = '207'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_tax_line ).
    run( iv_belnr = '1900000005' iv_mwskz = 'T6' iv_tax = '002' iv_type = '212'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_tax_line ).
  ENDMETHOD.

  METHOD conflicting_expense_lines.
    run( iv_belnr = '1900000006' iv_mwskz = 'T6' iv_tax = '001'
         iv_source = zcl_tax_vat2_islem_tur=>c_source_unresolved ).
  ENDMETHOD.

ENDCLASS.

CLASS zcl_tax_vat2_islem_tur DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! KDV2 - Belge vergi satırı için işlem türü (Kırılım 2) belirleme.
    "! Beyanname raporu ve Kesinti Yapılan Satıcılar raporu aynı kuralı
    "! kullansın diye tek yerde tutulur. Sıra:
    "!   1) Vergi kaleminin uyarlanan alanı (Tayin vb.) geçerli bir işlem türü ise o
    "!   2) Aynı belgede aynı vergi kodlu gider kaleminin alanı (tek değer ise)
    "!   3) Vergi kodu 'Diğer' (250) dışında tek işlem türüne bağlı ise o
    "!   4) Hiçbiri değilse "belirlenemedi" (belge raporda ayrı satırda gösterilir)
    TYPES ty_islem_tur TYPE ztax_t_k2ist-k2type .
    TYPES ty_source    TYPE c LENGTH 1 .

    TYPES:
      BEGIN OF ty_item,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        buzei TYPE n LENGTH 6,
        koart TYPE c LENGTH 1,
        buzid TYPE c LENGTH 1,
        mwskz TYPE mwskz,
        value TYPE c LENGTH 20,
      END OF ty_item .
    TYPES tt_item TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY .

    TYPES:
      BEGIN OF ty_taxitem,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        buzei TYPE n LENGTH 6,
        mwskz TYPE mwskz,
      END OF ty_taxitem .
    TYPES tt_taxitem TYPE STANDARD TABLE OF ty_taxitem WITH EMPTY KEY .

    TYPES:
      BEGIN OF ty_ist,
        k2type TYPE ty_islem_tur,
        mwskz  TYPE mwskz,
      END OF ty_ist .
    TYPES tt_ist TYPE STANDARD TABLE OF ty_ist WITH EMPTY KEY .

    TYPES tt_monat_range TYPE RANGE OF monat .

    "! Vergi kodu tevkifat işlem türü tablosunda yok (KDV2 konusu değil)
    CONSTANTS c_source_not_relevant TYPE ty_source VALUE space.
    "! Vergi kaleminden belirlendi
    CONSTANTS c_source_tax_line     TYPE ty_source VALUE 'T'.
    "! Gider kaleminden belirlendi
    CONSTANTS c_source_expense_line TYPE ty_source VALUE 'G'.
    "! Vergi kodunun tek işlem türünden belirlendi
    CONSTANTS c_source_tax_code     TYPE ty_source VALUE 'V'.
    "! Belirlenemedi
    CONSTANTS c_source_unresolved   TYPE ty_source VALUE 'U'.
    "! GİB KDV2 işlem türü 'Diğerleri'
    CONSTANTS c_islem_tur_diger     TYPE ty_islem_tur VALUE '250'.

    "! Dönemin belgelerini veritabanından okuyarak örnek oluşturur.
    "! @parameter iv_fieldname | ZTAX_T_K2ITA-FIELDNAME (ASSIGNMENTREFERENCE / XREF3)
    CLASS-METHODS create_from_db
      IMPORTING
        !iv_fieldname      TYPE csequence
        !iv_bukrs          TYPE bukrs
        !iv_gjahr          TYPE gjahr
        !ir_monat          TYPE tt_monat_range
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcl_tax_vat2_islem_tur .

    METHODS constructor
      IMPORTING
        !it_item    TYPE tt_item
        !it_taxitem TYPE tt_taxitem
        !it_ist     TYPE tt_ist .

    "! @parameter iv_taxitem   | Vergi satırı no (I_OperationalAcctgDocTaxItem-TaxItem)
    "! @parameter ev_islem_tur | Belirlenen işlem türü (kaynak U veya boş ise anlamsız)
    "! @parameter ev_source    | c_source_* sabitlerinden biri
    METHODS determine
      IMPORTING
        !iv_bukrs     TYPE bukrs
        !iv_belnr     TYPE belnr_d
        !iv_gjahr     TYPE gjahr
        !iv_mwskz     TYPE mwskz
        !iv_taxitem   TYPE clike
      EXPORTING
        !ev_islem_tur TYPE ty_islem_tur
        !ev_source    TYPE ty_source .

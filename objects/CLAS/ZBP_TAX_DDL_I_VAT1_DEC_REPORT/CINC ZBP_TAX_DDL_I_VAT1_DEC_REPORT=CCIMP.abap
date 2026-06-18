CLASS lhc_ZTAX_DDL_I_VAT1_DEC_REPORT DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.


    DATA mt_tevkifat                TYPE TABLE OF ztax_ddl_i_vat1_tev_report.
    TYPES BEGIN OF mty_collect.
    TYPES kiril1    TYPE ztax_t_kdv2g-kiril1.
    TYPES acklm1    TYPE ztax_t_k2k1-acklm.
    TYPES kiril2    TYPE ztax_t_kdv2g-kiril2.
    TYPES acklm2    TYPE ztax_t_k2k2-acklm.
    TYPES kiril3    TYPE ztax_t_k2k2-acklm.
    TYPES matrah    TYPE ztax_e_matrah.
    TYPES oran      TYPE ztax_e_vergi_oran.
    TYPES tevkifat  TYPE ztax_e_tevkifat.
    TYPES tevkifato TYPE ztax_e_tevkifat_oran.
    TYPES vergi     TYPE ztax_e_vergi.
    TYPES field_com(200) TYPE c.
    TYPES END OF mty_collect.

    TYPES BEGIN OF mty_other_collect.
    TYPES kiril1    TYPE ztax_t_kdv1g-kiril1.
    TYPES acklm1    TYPE ztax_t_k2k1-acklm.
    TYPES kiril2    TYPE ztax_t_kdv1g-kiril2.
    TYPES acklm2    TYPE  ztax_t_k2k1-acklm.
    TYPES kiril3    TYPE  ztax_t_k2k1-acklm.
    TYPES matrah    TYPE ztax_s_hier_kdv1-matrah.
    TYPES tevkifat  TYPE ztax_s_hier_kdv1-tevkifat.
    TYPES tevkifato TYPE ztax_s_hier_kdv1-tevkifato.
    TYPES vergi     TYPE ztax_s_hier_kdv1-vergi.
    TYPES END OF mty_other_collect.

    DATA p_monat TYPE monat.
    DATA p_gjahr TYPE gjahr.
    DATA p_bukrs TYPE bukrs.
    DATA p_donemb TYPE ztax_e_donemb.
    DATA p_beyant TYPE ztax_e_beyant.

    TYPES mty_x(256)       TYPE x.
    TYPES mtty_x           TYPE TABLE OF mty_x.


    DATA mt_collect                TYPE TABLE OF ztax_ddl_i_vat1_dec_report.
    DATA mr_monat TYPE RANGE OF monat.

  PRIVATE SECTION.
*
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR ztax_ddl_i_vat1_dec_report RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_vat1_dec_report RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ ztax_ddl_i_vat1_dec_report RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ztax_ddl_i_vat1_dec_report.

    METHODS CreateXml FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_vat1_dec_report~CreateXml RESULT result.

ENDCLASS.

CLASS lhc_ZTAX_DDL_I_VAT1_DEC_REPORT IMPLEMENTATION.

*  METHOD get_instance_features.
*  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD CreateXml.

    """YiğitcanÖzdemir"""

    DATA: lo_vat1_report TYPE REF TO zcl_tax_vat1_dec_report.
    CREATE OBJECT lo_vat1_report.

    DATA(lt_keys) = keys.

    READ TABLE lt_keys INTO DATA(ls_keys) INDEX 1.
    IF sy-subrc EQ 0.

      p_bukrs = ls_keys-bukrs.
      p_gjahr = ls_keys-gjahr.
      p_monat = ls_keys-monat.
      p_donemb = 01.
*
*
      CALL METHOD lo_vat1_report->kdv1
        EXPORTING
          iv_bukrs   = p_bukrs
          iv_gjahr   = p_gjahr
          iv_monat   = p_monat
          iv_donemb  = 01
          iv_beyant  = 02
        IMPORTING
          et_collect = mt_collect
          er_monat   = mr_monat.

    ENDIF.
    """YiğitcanÖzdemir"""

    TYPES BEGIN OF lty_bxmls.
    TYPES kiril1   TYPE ztax_t_k1k1s-kiril1.
    TYPES xmlsr    TYPE ztax_t_bxmls-xmlsr.
    TYPES seviye   TYPE ztax_T_bxmls-seviye.
    TYPES xmlacklm TYPE ztax_T_bxmls-xmlacklm.
    TYPES END OF lty_bxmls.

    TYPES BEGIN OF lty_beyg.
    TYPES bukrs    TYPE ztax_t_beyg-bukrs.
    TYPES vdkod    TYPE ztax_t_beyg-vdkod.
    TYPES mvkno    TYPE ztax_t_beyg-mvkno.
    TYPES mtckn    TYPE ztax_t_beyg-mtckn.
    TYPES msoyad   TYPE ztax_t_beyg-msoyad.
    TYPES mad      TYPE ztax_t_beyg-mad.
    TYPES memail   TYPE ztax_t_beyg-memail.
    TYPES malkod   TYPE ztax_t_beyg-malkod.
    TYPES mtelno   TYPE ztax_t_beyg-mtelno.
    TYPES hsvvkn   TYPE ztax_t_beyg-hsvvkn.
    TYPES hsv      TYPE ztax_t_beyg-hsv.
    TYPES hsvtckn  TYPE ztax_t_beyg-hsvtckn.
    TYPES hsvemail TYPE ztax_t_beyg-hsvemail.
    TYPES hsvakod  TYPE ztax_t_beyg-hsvakod.
    TYPES hsvtelno TYPE ztax_t_beyg-hsvtelno.
    TYPES dvkno    TYPE ztax_t_beyg-dvkno.
    TYPES dtckn    TYPE ztax_t_beyg-dtckn.
    TYPES dsoyad   TYPE ztax_t_beyg-dsoyad.
    TYPES dad      TYPE ztax_t_beyg-dad.
    TYPES demail   TYPE ztax_t_beyg-demail.
    TYPES dalkod   TYPE ztax_t_beyg-dalkod.
    TYPES dtelno   TYPE ztax_t_beyg-dtelno.
    TYPES tsicil   TYPE ztax_t_beyg-tsicil.
    TYPES END OF lty_beyg.

    DATA lv_donem_txt(30).
    DATA lv_value(100).
    DATA lv_beyanv        TYPE ztax_t_beyv-beyanv.
    DATA lv_dyolu         TYPE ztax_T_beydy-dyolu.
    DATA ls_beyg          TYPE lty_beyg.
    DATA lv_monat         TYPE monat.
    DATA lv_xml_string    TYPE string.
    DATA lv_xml           TYPE string.
    DATA lv_char_amount1  TYPE string.
    DATA lv_char_amount2  TYPE string.
    DATA lv_char_amount3  TYPE string.
    DATA lv_char_amount4  TYPE string.
    DATA lv_islem         TYPE string.
    DATA lv_ad            TYPE string.
    DATA lv_oran          TYPE string.
    DATA lv_ek_tckn       TYPE string.
    DATA lv_ek_unvan      TYPE string.
    DATA lv_ek_tarih      TYPE string.
    DATA lv_ek_serino     TYPE string.
    DATA lv_ek_sırano     TYPE string.
    DATA lt_ozel          TYPE TABLE OF ztax_ddl_i_vat1_dec_report.
    DATA lt_kiril1        TYPE TABLE OF ztax_ddl_i_vat1_dec_report.
    DATA lt_kiril2        TYPE TABLE OF ztax_ddl_i_vat1_dec_report.
    DATA lt_kiril3        TYPE TABLE OF ztax_ddl_i_vat1_dec_report.
    DATA lt_kiril3_sum    TYPE TABLE OF ztax_ddl_i_vat1_dec_report.
    DATA lt_kiril_tmp     TYPE TABLE OF ztax_ddl_i_vat1_dec_report.
    DATA lt_kiril3_other  TYPE TABLE OF mty_other_collect.
    DATA ls_kiril1        TYPE ztax_ddl_i_vat1_dec_report.
    DATA ls_kiril2        TYPE ztax_ddl_i_vat1_dec_report.
    DATA ls_kiril3        TYPE ztax_ddl_i_vat1_dec_report.
    DATA ls_kiril3_cntrl  TYPE ztax_ddl_i_vat1_dec_report.
    DATA ls_kiril3_sum    TYPE ztax_ddl_i_vat1_dec_report.
    DATA ls_kiril3_other  TYPE mty_other_collect.
    DATA ls_kiril3_ek     TYPE ztax_ddl_i_vat1_dec_report.
    DATA ls_kiril3_tmp    TYPE ztax_ddl_i_vat1_dec_report.
    DATA lt_bxmls         TYPE TABLE OF lty_bxmls.
    DATA ls_bxmls         TYPE lty_bxmls.
    DATA lt_bxmls_gk1     TYPE TABLE OF lty_bxmls.
    DATA ls_bxmls_gk1     TYPE lty_bxmls.
    DATA lv_kodver        TYPE string.
    DATA lv_nonamespace   TYPE string.
    DATA lv_xmlstring     TYPE string.
    DATA lt_bxmls_desc    TYPE TABLE OF lty_bxmls.
    DATA ls_bxmls_desc    TYPE lty_bxmls.
    DATA lv_vdkod         TYPE string.
    DATA lv_tip           TYPE string.
    DATA lv_yil           TYPE string.
    DATA lv_ay            TYPE string.
    DATA lv_mvergino      TYPE string.
    DATA lv_mtckimlikno   TYPE string.
    DATA lv_msoyadi       TYPE string.
    DATA lv_madi          TYPE string.
    DATA lv_meposta       TYPE string.
    DATA lv_malankodu     TYPE string.
    DATA lv_mtelno        TYPE string.
    DATA lv_hsv           TYPE string.
    DATA lv_hsvsoyadi     TYPE string.
    DATA lv_hsvadi        TYPE string.
    DATA lv_hsvvergino    TYPE string.
    DATA lv_hsvtckimlikno TYPE string.
    DATA lv_hsveposta     TYPE string.
    DATA lv_hsvalankodu   TYPE string.
    DATA lv_hsvtelno      TYPE string.
    DATA lv_dvergino      TYPE string.
    DATA lv_dtckimlikno   TYPE string.
    DATA lv_dsoyadi       TYPE string.
    DATA lv_dadi          TYPE string.
    DATA lv_deposta       TYPE string.
    DATA lv_dalankodu     TYPE string.
    DATA lv_dtelno        TYPE string.
    DATA lv_tsicil        TYPE string.
    DATA lv_filename      TYPE string.
    DATA lt_x             TYPE mtty_x.
    DATA lv_size          TYPE i.
    DATA lv_tabix         TYPE sy-tabix.
*    DATA lt_hsv_val       TYPE mtty_dd07v.
*    DATA ls_hsv_val       TYPE dd07v.
    DATA lv_kiril3_loop(1).
    DATA lv_index TYPE sy-tabix.
    DATA: lt_rule          TYPE TABLE OF ztax_T_k1k2s,
          ls_rule          TYPE ztax_T_k1k2s,
          lv_toplam_matrah TYPE I_SalesOrder-TotalNetAmount,
          lv_toplam_kdv    TYPE I_SalesOrder-TotalNetAmount.

    DATA lv_indirim_tur   TYPE string.


    DATA : lv_islembedel TYPE ztax_ddl_i_vat1_dec_report-vergi.

*    me->tevkifat( ).
    FIELD-SYMBOLS <fs>       TYPE any.
    FIELD-SYMBOLS <fs_value> TYPE any.
    FIELD-SYMBOLS <fs_line> TYPE any.




    READ TABLE mr_monat ASSIGNING <fs> INDEX 1.
    IF <fs> IS ASSIGNED.
      ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        lv_monat = <fs_value>.
        UNASSIGN <fs_value>.
      ENDIF.
      UNASSIGN <fs>.
    ENDIF.
*
*    me->doma_get_value( EXPORTING iv_domain_name = '/ITETR/TAX_HSV'
*                        IMPORTING et_dom_value   = lt_hsv_val ).


    CASE p_donemb.
      WHEN '01'.
        lv_donem_txt = 'aylik'.
      WHEN '02'.
        lv_donem_txt = '3 Aylık'.
    ENDCASE.
    SELECT SINGLE *
           FROM ztax_t_beyg
           WHERE bukrs EQ @p_bukrs
           INTO CORRESPONDING FIELDS OF @ls_beyg.

    DATA : lv_sifat TYPE string.

    IF ls_beyg-hsv EQ 1.
      lv_sifat = 'Temsilci'.
    ELSEIF ls_beyg-hsv  EQ 2.
      lv_sifat = 'Kendisi'.
    ENDIF.

    SELECT SINGLE beyanv
           FROM ztax_t_beyv
           WHERE beyant EQ '01'
           INTO @lv_beyanv.

    SELECT SINGLE dyolu
           FROM ztax_t_beydy
           WHERE bukrs EQ @p_bukrs
             AND beyant EQ '01'
             INTO @lv_dyolu.


    SELECT ztax_t_k1k1s~kiril1,
           ztax_t_bxmls~xmlsr,
           ztax_t_bxmls~seviye,
           ztax_t_bxmls~xmlacklm

           FROM ztax_t_k1k1s
           INNER JOIN ztax_T_bxmls
           ON ztax_t_bxmls~xmlsr EQ ztax_t_k1k1s~xmlsr
           WHERE ztax_t_k1k1s~bukrs EQ @p_bukrs
           INTO TABLE @lt_bxmls.

    SELECT bukrs,
           kiril1,
           kiril2,
           kural
           FROM ztax_t_k1k2s
           WHERE bukrs EQ @p_bukrs
           INTO CORRESPONDING FIELDS OF TABLE @lt_rule.

    SELECT mwskz,
           oran
      FROM ztax_T_voran

      WHERE bukrs EQ @p_bukrs
      INTO TABLE @DATA(lt_vergioran).


    FIELD-SYMBOLS <fs_out_tev> TYPE STANDARD TABLE.       "YiğitcanÖzdemir

    DATA: lo_vat1_tev TYPE REF TO zcl_tax_vat1_tev_report.
    CREATE OBJECT lo_vat1_tev.

    lt_keys = keys.

    READ TABLE lt_keys INTO ls_keys INDEX 1.
    IF sy-subrc EQ 0.

*
      p_bukrs = ls_keys-bukrs.
      p_gjahr = ls_keys-gjahr.
      p_monat = ls_keys-monat.
*
    ENDIF.
*
    CALL METHOD lo_vat1_tev->get_data
      EXPORTING
        iv_bukrs  = p_bukrs
        iv_gjahr  = p_gjahr
        iv_monat  = p_monat
        iv_donemb = 1
      IMPORTING
        et_result = mt_tevkifat.

    ASSIGN mt_tevkifat TO <fs_out_tev>.

    SORT lt_bxmls BY xmlsr ASCENDING kiril1 ASCENDING seviye ASCENDING.

    lt_bxmls_gk1 = lt_bxmls.
    DELETE ADJACENT DUPLICATES FROM lt_bxmls_gk1 COMPARING xmlsr kiril1.

    lt_kiril1 = mt_collect.
    lt_kiril2 = mt_collect.
    lt_kiril3 = mt_collect.

    lt_ozel  = mt_collect.

    SORT lt_ozel BY kiril1 ASCENDING kiril2 ASCENDING.

    SORT lt_kiril1 BY kiril1 ASCENDING kiril2 ASCENDING.
    DELETE lt_kiril2 WHERE kiril3 NE space OR kiril2 EQ '000'.
    SORT lt_kiril2 BY kiril1 kiril2.
    DELETE ADJACENT DUPLICATES FROM lt_kiril1 COMPARING kiril1.
    DELETE ADJACENT DUPLICATES FROM lt_kiril2 COMPARING kiril1 kiril2.

    SORT lt_kiril3 BY kiril1 kiril2 ASCENDING kiril3 DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_kiril3 COMPARING kiril1 kiril2 kiril3 oran.
    "DELETE ADJACENT DUPLICATES FROM lt_kiril3 COMPARING kiril1 kiril2 matrah vergi.
*    SORT lt_kiril3 BY kiril1 kiril2 kiril3.
    SORT lt_kiril3 ASCENDING BY kiril1 kiril2 kiril3 matrah vergi.
    DELETE ADJACENT DUPLICATES FROM lt_kiril3 COMPARING kiril1 kiril2 kiril3 matrah vergi.
    SORT lt_kiril3 BY kiril1 kiril2 matrah vergi  ASCENDING oran DESCENDING.
    " DELETE ADJACENT DUPLICATES FROM lt_kiril3 COMPARING kiril1 kiril2 matrah vergi.
    DELETE lt_kiril3 WHERE kiril1 EQ '013' AND kiril2 NE space AND kiril3 EQ space.

    DELETE lt_kiril3 WHERE kiril1 EQ '011' AND kiril2 NE space AND kiril3 NE space.
    DELETE lt_kiril3 WHERE kiril1 EQ '005' AND matrah IS INITIAL AND kiril2 NE space AND kiril3 NE space.

    LOOP AT lt_kiril3 INTO ls_kiril3.
      READ TABLE lt_vergioran INTO DATA(ls_vergioran) WITH KEY mwskz = ls_kiril3-kiril3.
      IF sy-subrc EQ 0.
        ls_kiril3-oran = ls_vergioran-oran.
      ENDIF.
      MOVE-CORRESPONDING ls_kiril3 TO ls_kiril3_sum.
      CLEAR ls_kiril3_sum-kiril3.
      COLLECT ls_kiril3_sum INTO lt_kiril3_sum.
    ENDLOOP.

    LOOP AT lt_kiril2 INTO ls_kiril2 WHERE kiril1 EQ '005'.
      MOVE-CORRESPONDING ls_kiril2 TO ls_kiril3_other.
      CLEAR ls_kiril3_other-kiril3.
      COLLECT ls_kiril3_other INTO lt_kiril3_other.
    ENDLOOP.

    DELETE lt_kiril3_sum WHERE kiril1 EQ '005'.
    LOOP AT lt_kiril3_other INTO ls_kiril3_other WHERE kiril1 EQ '005'.
      APPEND INITIAL LINE TO lt_kiril3_sum ASSIGNING FIELD-SYMBOL(<ls_kiril3_sum>).
      MOVE-CORRESPONDING ls_kiril3_other TO <ls_kiril3_sum>.
    ENDLOOP.
    SORT lt_kiril3_sum BY kiril1 kiril2 matrah vergi  ASCENDING oran DESCENDING.

    DELETE lt_kiril3_sum WHERE ( kiril1 = '016' OR kiril1 = '019' )
                           AND ( oran = '0' ) .
    lt_bxmls_desc = lt_bxmls.

    SORT lt_bxmls_desc BY xmlsr ASCENDING kiril1 ASCENDING seviye DESCENDING.

    CONCATENATE 'kodVer="'
                 lv_beyanv
                 '"'
                 INTO lv_kodver.

    CONCATENATE 'xsi:noNamespaceSchemaLocation="'
                 lv_beyanv
                 '.xsd"'
                 INTO lv_nonamespace.

    CONCATENATE '<vdKodu>'
                ls_beyg-vdkod
                '</vdKodu>'
                INTO lv_vdkod.

    CONCATENATE '<tip>'
                lv_donem_txt
                '</tip>'
                INTO lv_tip.

    CONCATENATE '<yil>'
                p_gjahr
                '</yil>'
                INTO lv_yil.

    CONCATENATE '<ay>'
                p_monat
                '</ay>'
                INTO lv_ay.
*                 INTO p_monat.

    CONCATENATE '<vergiNo>'
                 ls_beyg-mvkno
                 '</vergiNo>'
                INTO lv_mvergino.

    IF ls_beyg-mtckn IS NOT INITIAL.
      CONCATENATE '<tcKimlikNo>'
                  ls_beyg-mtckn
                  '</tcKimlikNo>'
                  INTO lv_mtckimlikno.
    ENDIF.

    CONCATENATE '<soyadi>'
                ls_beyg-msoyad
                '</soyadi>'
                INTO lv_msoyadi.

    CONCATENATE '<adi>'
                ls_beyg-mad
                '</adi>'
                INTO lv_madi.

    CONCATENATE '<eposta>'
                ls_beyg-memail
                '</eposta>'
                INTO lv_meposta.

    CONCATENATE '<alanKodu>'
                ls_beyg-malkod
                '</alanKodu>'
                INTO lv_malankodu.

    CONCATENATE '<telNo>'
                ls_beyg-mtelno
                '</telNo>'
                 INTO lv_mtelno.

*    CLEAR ls_hsv_val.
*    READ TABLE lt_hsv_val INTO ls_hsv_val WITH KEY domvalue_l = ls_beyg-hsv.

    CONCATENATE '<hsv sifat="'
*                ls_hsv_val-ddtext
                lv_sifat
                '">'
                INTO lv_hsv.

    CONCATENATE '<soyadi>'
                ls_beyg-msoyad
                '</soyadi>'
                INTO lv_hsvsoyadi.

    CONCATENATE '<adi>'
                ls_beyg-mad
                '</adi>'
                INTO lv_hsvadi.

    CONCATENATE '<vergiNo>'
                 ls_beyg-hsvvkn
                '</vergiNo>'
                INTO lv_hsvvergino.

    CONCATENATE '<tcKimlikNo>'
                ls_beyg-hsvtckn
                '</tcKimlikNo>'
                INTO lv_hsvtckimlikno.

    CONCATENATE '<eposta>'
                ls_beyg-hsvemail
                '</eposta>'
                INTO lv_hsveposta.

    CONCATENATE '<alanKodu>'
                ls_beyg-hsvakod
                '</alanKodu>'
                INTO lv_hsvalankodu.

    CONCATENATE '<telNo>'
                ls_beyg-hsvtelno
                '</telNo>'
          INTO lv_hsvtelno.

    CONCATENATE '<vergiNo>'
                ls_beyg-dvkno
                '</vergiNo>'
                INTO lv_dvergino.

    IF ls_beyg-dtckn IS NOT INITIAL.
      CONCATENATE '<tcKimlikNo>'
                  ls_beyg-dtckn
                  '</tcKimlikNo>'
                  INTO lv_dtckimlikno.
    ENDIF.

    CONCATENATE '<soyadi>'
                ls_beyg-dsoyad
                '</soyadi>'
                INTO lv_dsoyadi.

    CONCATENATE '<adi>'
                ls_beyg-dad
                '</adi>'
                INTO lv_dadi.

    CONCATENATE '<eposta>'
                ls_beyg-demail
                '</eposta>'
                INTO lv_deposta.

    CONCATENATE '<alanKodu>'
                ls_beyg-dalkod
                '</alanKodu>'
                INTO lv_dalankodu.

    CONCATENATE '<telNo>'
                ls_beyg-dtelno
                '</telNo>'
                INTO lv_dtelno.

    CONCATENATE '<ticSicilNo>'
                ls_beyg-tsicil
                '</ticSicilNo>'
                INTO lv_tsicil.

    CONCATENATE '<?xml version="1.0" encoding="UTF-8"?>'
                '<beyanname'
                lv_kodver
                'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
                lv_nonamespace
                '>'
                '<genel>'
                '<idari>'
                lv_vdkod
                '<donem>'
                lv_tip
                lv_yil
                lv_ay
                '</donem>'
                '</idari>'
                '<mukellef>'
                lv_mvergino
                lv_mtckimlikno
                lv_msoyadi
                lv_madi
                lv_meposta
                lv_malankodu
                lv_mtelno
                lv_tsicil
                '</mukellef>'
                lv_hsv
                lv_hsvsoyadi
                lv_hsvadi
                lv_hsvvergino
                lv_hsvtckimlikno
                lv_tsicil
                lv_hsveposta
                lv_hsvalankodu
                lv_hsvtelno
                '</hsv>'
                '<duzenleyen>'
                lv_dvergino
                lv_dtckimlikno
                lv_dsoyadi
                lv_dadi
                lv_deposta
                lv_dalankodu
                lv_dtelno
                lv_tsicil
                '</duzenleyen>'
                '</genel>'
                '<ozel>'
                INTO lv_xml_string
                SEPARATED BY space.

    LOOP AT lt_bxmls_gk1 INTO ls_bxmls_gk1.
      IF ls_bxmls_gk1-kiril1 EQ '109' .
        CONTINUE.
      ENDIF.
      IF ls_bxmls_gk1-kiril1 EQ '99'.

        lv_xml = '<ozelMatrahSekliTespitEdilenler>'.
        CONCATENATE lv_xml_string
             lv_xml
             INTO lv_xml_string
             SEPARATED BY space.
        CLEAR lv_xml.



        LOOP AT lt_ozel INTO DATA(ls_ozel) WHERE kiril1 = '99' .
          IF ls_ozel-kiril3 IS NOT INITIAL.

            IF ls_ozel-kiril3 CS '0'.

              CLEAR lv_char_amount2.
              lv_char_amount2 = ls_ozel-matrah.
              CONDENSE lv_char_amount2 NO-GAPS.
              CONCATENATE
                          '<ozelMatrahSekliTespitEdilen>'
                          '<ozelMatrahSekliTespitBildirimTuru>KDV_HESAPLAMAKSIZIN</ozelMatrahSekliTespitBildirimTuru>'
                          '<ozelMatrahaDahilOlmayan>' lv_char_amount2 '</ozelMatrahaDahilOlmayan>'
                          '</ozelMatrahSekliTespitEdilen>'
              INTO lv_xml.

              CONCATENATE lv_xml_string
                   lv_xml
                   INTO lv_xml_string
                   SEPARATED BY space.
            ELSE.

              CLEAR lv_xml.

              CLEAR lv_char_amount1.
              CLEAR lv_char_amount2.
              IF ls_ozel-vergi NE 0.
                lv_char_amount1 = ls_ozel-vergi.
                lv_char_amount2 = ls_ozel-matrah.
                lv_islembedel = ls_ozel-vergi + ls_ozel-matrah.
                lv_char_amount3 = lv_islembedel.
                CONDENSE lv_char_amount1 NO-GAPS.
                CONDENSE lv_char_amount2 NO-GAPS.
                CONDENSE lv_char_amount3 NO-GAPS.
              ENDIF.
              CONCATENATE
                     '<ozelMatrahSekliTespitEdilen>'
                     '<ozelMatrahSekliTespitBildirimTuru>'
                     'KDV_HESAPLAYARAK'
                     '</ozelMatrahSekliTespitBildirimTuru>'
                     '<ozelMatrahSekliTespitIslemTuru>'
                     ls_ozel-islem_tur
                     '</ozelMatrahSekliTespitIslemTuru>'
                     '<islemBedeli>'
                     lv_char_amount3
                     '</islemBedeli>'
                     '<islemBedDusulecekTutar>'
                     '0'
                     '</islemBedDusulecekTutar>'
                       '<matrah>'
                     lv_char_amount2
                     '</matrah>'
                        '<kdvOran>'
                     ls_ozel-oran
                     '</kdvOran>'
                       '<vergi>'
                     lv_char_amount1
                     '</vergi>'
                     '<ozelMatrahaDahilOlmayan>'
                     '0'
                     '</ozelMatrahaDahilOlmayan>'
                     '</ozelMatrahSekliTespitEdilen>'
                     INTO lv_xml.

              CONCATENATE lv_xml_string
                   lv_xml
                   INTO lv_xml_string
                   SEPARATED BY space.
            ENDIF.
          ENDIF.
        ENDLOOP.


        lv_xml = '</ozelMatrahSekliTespitEdilenler>'.
        CONCATENATE lv_xml_string
             lv_xml
             INTO lv_xml_string
             SEPARATED BY space.
        CLEAR lv_xml.
        IF ls_bxmls_gk1-kiril1 EQ '99'.
          CONTINUE.
        ENDIF.


      ENDIF.
      IF ls_bxmls_gk1-kiril1 EQ '031'.
        CLEAR lv_xml.
        CONCATENATE '<'
                    'ekler'
                    '>'
                    INTO lv_xml.

        CONCATENATE lv_xml_string
                    lv_xml
                    INTO lv_xml_string
                    SEPARATED BY space.

        READ TABLE lt_kiril1 INTO ls_kiril1 WHERE kiril1 = '109'.
        IF sy-subrc EQ 0 .
          CLEAR lv_xml.
          DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
          DATA(lv_currentdate) = |{ lv_date+6(2) }{ lv_date+4(2) }{ lv_date+0(4) }|.

          CLEAR lv_char_amount1.
          IF ls_kiril1-vergi NE 0.
            lv_char_amount1 = ls_kiril1-vergi.
            CONDENSE lv_char_amount1 NO-GAPS.
          ENDIF.
          CONCATENATE '<kdv109sorumluSifatiylaOdenenBildirimler>'
                      '<kdv109sorumluSifatiylaOdenenBildirim>'
                      '<odemeTur>'
                      ls_kiril1-odeme_tur
                      '</odemeTur>'
                      '<vergilendirmeDonemi>'
                      p_gjahr
                      p_monat
                      p_gjahr
                      p_monat
                      '</vergilendirmeDonemi>'
                      '<odemeMahsupDilekceTarihi>'
                      '</odemeMahsupDilekceTarihi>'
                      '<tutar>'
                     lv_char_amount1
                      '</tutar>'
                      '</kdv109sorumluSifatiylaOdenenBildirim>'
                      '</kdv109sorumluSifatiylaOdenenBildirimler>'
       INTO lv_xml.

          CONCATENATE lv_xml_string
               lv_xml
               INTO lv_xml_string
               SEPARATED BY space.
        ENDIF.


        "29122025 Tevkifatlıekler
        CLEAR lv_xml.
        CONCATENATE '<'
            'kismiTevkifatUygulananlarEk'
            '>'
            INTO lv_xml.


        CONCATENATE lv_xml_string
                    lv_xml
                    INTO lv_xml_string
                    SEPARATED BY space.

        LOOP AT mt_tevkifat INTO DATA(ls_tev).


          READ TABLE mt_collect INTO DATA(ls_collect) WITH KEY kiril3 = ls_tev-mwskz.
          IF sy-subrc EQ 0.
            DATA(lv_islemturu) = ls_collect-kiril2.
          ENDIF.
          CLEAR lv_xml.

          CLEAR lv_char_amount1.
          lv_char_amount1 = abs( ls_tev-matrah ).
          lv_char_amount2 = abs( ls_tev-kbetr ).
          lv_char_amount3 = abs( ls_tev-heskdv ).
          lv_char_amount4 = abs( ls_tev-vergi ).
          CONDENSE lv_char_amount1 NO-GAPS.
          CONDENSE lv_char_amount2 NO-GAPS.
          CONDENSE lv_char_amount3 NO-GAPS.
          CONDENSE lv_char_amount4 NO-GAPS.
          CONCATENATE '<kismiTevkifatUygulananEk>'
                      '<vkn>'
                      ls_tev-stcd2
                      '</vkn>'
                      '<unvan>'
                      ls_tev-name1
                      '</unvan>'
                      '<faturaTuru>'
                      '1'
                      '</faturaTuru>'
                      '<faturaBelgeTarihi>'
                      ls_tev-bldat+6(2)
                      ls_tev-bldat+4(2)
                      ls_tev-bldat(4)
                      '</faturaBelgeTarihi>'
                      '<seriSiraNo>'
                      ls_tev-sirano
                      '</seriSiraNo>'
                      '<kismiTevkifatUygulananIslemTuru>'
                      lv_islemturu
                      '</kismiTevkifatUygulananIslemTuru>'
                      '<matrah>'
                      lv_char_amount1
                      '</matrah>'
                      '<oran>'
                      lv_char_amount2
                      '</oran>'
                      '<hesaplananKDV>'
                      lv_char_amount3
                      '</hesaplananKDV>'
                      '<tevkifatOrani>'
                      ls_tev-tevkifato
                      '</tevkifatOrani>'
                      '<vergi>'
                      lv_char_amount4
                      '</vergi>'
                      '</kismiTevkifatUygulananEk>'
       INTO lv_xml.

          CONCATENATE lv_xml_string
               lv_xml
               INTO lv_xml_string
               SEPARATED BY space.
          CLEAR : lv_char_amount1, lv_char_amount2,lv_char_amount3,lv_char_amount4,lv_islemturu.
        ENDLOOP.

        CLEAR lv_xml.
        CONCATENATE '</'
            'kismiTevkifatUygulananlarEk'
            '>'
            INTO lv_xml.


        CONCATENATE lv_xml_string
                    lv_xml
                    INTO lv_xml_string
                    SEPARATED BY space.

      ENDIF.

      LOOP AT lt_kiril1 INTO ls_kiril1 WHERE kiril1 EQ ls_bxmls_gk1-kiril1.
        IF ( ls_kiril1-matrah EQ '0.00'
          AND ls_kiril1-vergi  EQ '0.00' )
         AND ls_kiril1-kiril1 NE '030'
         AND ls_kiril1-kiril1 NE '34'.

*        IF ( ls_kiril1-matrah EQ '0.00' AND ls_kiril1-vergi EQ '0.00' ) AND ( ls_kiril1-kiril1 NE '030' ).
          CONTINUE.
        ENDIF.
        CASE ls_bxmls_gk1-seviye .

          WHEN '900'.

            CLEAR lv_char_amount1.
            IF ls_kiril1-vergi NE 0.
              lv_char_amount1 = ls_kiril1-vergi.
            ELSEIF ls_kiril1-matrah NE 0.
              lv_char_amount1 = ls_kiril1-matrah.
            ELSEIF ls_kiril1-tevkifat NE 0.
              lv_char_amount1 = ls_kiril1-tevkifat.
            ENDIF.
            IF ls_kiril1-kiril1 EQ '030' AND lv_char_amount1 IS INITIAL.
              lv_char_amount1 = '0.00'.
            ENDIF.

            CLEAR lv_xml.
            CONCATENATE '<'
                        ls_bxmls_gk1-xmlacklm
                        '>'
                        lv_char_amount1
                        '</'
                        ls_bxmls_gk1-xmlacklm
                        '>'
                        INTO lv_xml.
            CONDENSE lv_xml NO-GAPS.
            CONCATENATE lv_xml_string
                        lv_xml
                        INTO lv_xml_string
                        SEPARATED BY space.

          WHEN OTHERS.

            IF ls_kiril1-kiril1 EQ '031'."YiğitcanÖzdemir
              CONTINUE.
            ENDIF.

            CLEAR lv_xml.
            READ TABLE lt_bxmls INTO ls_bxmls WITH KEY kiril1 = ls_kiril1-kiril1.
            IF sy-subrc IS INITIAL.
              CLEAR lv_xml.
              CONCATENATE '<'
              ls_bxmls-xmlacklm
              '>'
              INTO lv_xml.

              CONCATENATE lv_xml_string
                          lv_xml
                          INTO lv_xml_string
                          SEPARATED BY space.
            ENDIF.

            CLEAR lv_xml.
            CLEAR lv_kiril3_loop.
            LOOP AT lt_kiril2 INTO ls_kiril2 WHERE kiril1 EQ ls_kiril1-kiril1.
              CLEAR lv_index.
              LOOP AT lt_kiril3_sum INTO ls_kiril3 WHERE kiril1 EQ ls_kiril1-kiril1
                                                     AND kiril2 EQ ls_kiril2-kiril2.

*                IF ( ls_kiril3-matrah EQ '0.00' AND ls_kiril3-vergi EQ '0.00' ) AND ls_kiril3-kiril1 NE '030'."Kredi Kartı sıfır XML'de görünsün isteniyor.
                IF ( ls_kiril3-matrah EQ '0.00'
                    AND ls_kiril3-vergi  EQ '0.00' )
                    AND ls_kiril3-kiril1 NE '030'
                    AND ls_kiril3-kiril1 NE '34'.
                  CONTINUE.
                ENDIF.
                READ TABLE lt_rule INTO ls_rule WITH KEY kiril1 = ls_kiril3-kiril1
                                                         kiril2 = ls_kiril3-kiril2.

                IF NOT ( ls_kiril1-kiril1 EQ '011' OR ls_kiril1-kiril1 EQ '005' ).
                  IF ( ls_rule-kural EQ '001' OR ls_rule-kural EQ '003' ) AND ( ls_kiril3-oran EQ space OR ls_kiril3-oran EQ '0' ).
                    CONTINUE.
                  ENDIF.
                ENDIF.


                READ TABLE lt_bxmls_desc INTO ls_bxmls_desc WITH KEY kiril1 = ls_kiril1-kiril1.
                IF sy-subrc IS INITIAL.
                  CLEAR lv_xml.
                  CONCATENATE '<'
                              ls_bxmls_desc-xmlacklm
                              '>'
                              INTO lv_xml.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  IF ls_bxmls_desc-xmlacklm EQ 'kismiTevkifatUygulananEk'.
                    lv_index = lv_index + 1.
                    IF <fs_out_tev> IS ASSIGNED.
                      READ TABLE <fs_out_tev> ASSIGNING <fs_line> INDEX lv_index.
                    ENDIF.
                  ENDIF.
                ENDIF.

                CLEAR lv_xml.
                CLEAR lv_char_amount1.
                CLEAR lv_char_amount2.
                CLEAR lv_char_amount3.
                CLEAR lv_islem.
                CLEAR lv_oran.
                CLEAR lv_ad.
                CLEAR lv_ek_tckn.
                CLEAR lv_ek_unvan.
                CLEAR lv_ek_tarih.
                CLEAR lv_ek_serino.
                CLEAR lv_ek_sırano.

                IF <fs_line> IS ASSIGNED.
                  ASSIGN COMPONENT 'STCD2' OF STRUCTURE <fs_line> TO <fs_value>.
                  IF <fs_value> IS ASSIGNED.
                    lv_ek_tckn = <fs_value>.
                    UNASSIGN <fs_value>.
                  ENDIF.
                  ASSIGN COMPONENT 'NAME1' OF STRUCTURE <fs_line> TO <fs_value>.
                  IF <fs_value> IS ASSIGNED.
                    lv_ek_unvan = <fs_value>.
                    UNASSIGN <fs_value>.
                  ENDIF.
                  ASSIGN COMPONENT 'BLDAT' OF STRUCTURE <fs_line> TO <fs_value>.
                  IF <fs_value> IS ASSIGNED.
                    lv_ek_tarih = <fs_value>.
                    lv_ek_tarih =  |{ lv_ek_tarih+6(2) }| & |{ lv_ek_tarih+4(2) }| & |{ lv_ek_tarih(4) }|.
                    UNASSIGN <fs_value>.
                  ENDIF.
                  ASSIGN COMPONENT 'SERINO' OF STRUCTURE <fs_line> TO <fs_value>.
                  IF <fs_value> IS ASSIGNED.
                    lv_ek_serino = <fs_value>.
                    UNASSIGN <fs_value>.
                  ENDIF.
                  ASSIGN COMPONENT 'SIRANO' OF STRUCTURE <fs_line> TO <fs_value>.
                  IF <fs_value> IS ASSIGNED.
                    lv_ek_sırano = <fs_value>.
                    UNASSIGN <fs_value>.
                  ENDIF.
                  UNASSIGN <fs>.
                ENDIF.

                lv_char_amount1 = ls_kiril3-matrah.
                lv_char_amount2 = ls_kiril3-oran.
                lv_char_amount3 = ls_kiril3-vergi.
                lv_islem        = ls_kiril3-kiril2.
                lv_oran         = ls_kiril3-tevkifato.
                lv_ad           = ls_kiril3-acklm2.
                SHIFT lv_char_amount1 LEFT DELETING LEADING space.
                SHIFT lv_char_amount2 LEFT DELETING LEADING space.
                SHIFT lv_char_amount3 LEFT DELETING LEADING space.

                IF lv_islem IS NOT INITIAL AND ( ls_kiril3-kiril1 EQ '003'  )."OR ls_kiril3-kiril1 EQ '031' ).

                  IF ls_kiril3-kiril1 EQ '031'.
                    READ TABLE lt_kiril3 INTO ls_kiril3_ek WITH KEY kiril1 = '003'
                                                                 kiril3 = ls_kiril3-kiril3.
                    IF sy-subrc EQ 0.
                      lv_islem = ls_kiril3_ek-kiril2.
                    ENDIF.

                  ENDIF.

                  CLEAR lv_xml.
                  CONCATENATE '<kismiTevkifatUygulananIslemTuru>'
                              lv_islem
                              '</kismiTevkifatUygulananIslemTuru>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<tevkifatOrani>'
                              lv_oran
                              '</tevkifatOrani>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                ENDIF.

                IF lv_islem IS NOT INITIAL AND ls_kiril3-kiril1 EQ '005'.

                  CLEAR lv_xml.
                  CONCATENATE '<islemTuru>'
                              lv_islem
                              '</islemTuru>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                ENDIF.

                IF ls_kiril3-kiril1 EQ '015'."<<Alper NANTU 015 için alt tagler eklendi ve NE 13 015 için muaf tutuldu.
                  CLEAR lv_xml.
                  CONCATENATE '<ihracKayitliTeslimlerIslemTuru>'
                              ls_kiril3-kiril2
                              '</ihracKayitliTeslimlerIslemTuru>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<teslimBedeli>'
                              lv_char_amount1
                              '</teslimBedeli>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<oran>'
                              '0.00'
                              '</oran>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<hesaplananKDV>'
                              '0.00'
                              '</hesaplananKDV>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

*                ELSEIF ls_kiril3-kiril1 NE '013'.                        "YiğitcanÖzdemir 16122025 kapatıldı
*                  CLEAR lv_xml.
*                  CONCATENATE '<matrah>'
*                              lv_char_amount1
*                              '</matrah>'
*                              INTO lv_xml.
*                  CONDENSE lv_xml NO-GAPS.
*
*                  CONCATENATE lv_xml_string
*                              lv_xml
*                              INTO lv_xml_string
*                              SEPARATED BY space.
*                ENDIF.
*                IF ls_kiril3-kiril1 NE '015'."Alper NANTU 015 için         "YiğitcanÖzdemir 16122025 kapatıldı

                ELSEIF NOT ( ls_kiril3-kiril1 EQ '013' OR ls_kiril3-kiril1 EQ '034' ) . "YiğitcanÖzdemir 16122025 açıldı
                  IF ls_kiril3-islem_tur IS NOT INITIAL.
                    CLEAR lv_xml.
                    CONCATENATE '<tevkifatUygulanmayanIslemTuru>'
                                ls_kiril3-islem_tur
                                '</tevkifatUygulanmayanIslemTuru>'
                                INTO lv_xml.
                    CONDENSE lv_xml NO-GAPS.

                    CONCATENATE lv_xml_string
                                lv_xml
                                INTO lv_xml_string
                                SEPARATED BY space.
                  ENDIF.
                  CLEAR lv_xml.
                  CONCATENATE '<matrah>'
                              lv_char_amount1
                              '</matrah>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.
                ENDIF.
                IF NOT ( ls_kiril3-kiril1 EQ '015' OR ls_kiril3-kiril1 EQ '034' ) ."Alper NANTU 015 için "YiğitcanÖzdemir 16122025 açıldı



                  CLEAR lv_xml.

                  CONCATENATE '<oran>'
                              lv_char_amount2
                              '</oran>'
                              INTO lv_xml.

                  CONDENSE lv_xml NO-GAPS.
                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                ENDIF."Alper NANTU 015 için bu if eklendi.
                IF lv_islem IS NOT INITIAL AND ls_kiril3-kiril1 EQ '011'.

                  CLEAR lv_xml.
                  CONCATENATE '<indirimTuru>'
                              lv_islem
                              '</indirimTuru>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.
                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.


                ENDIF.

                IF lv_islem IS NOT INITIAL AND ls_kiril3-kiril1 EQ '016'.

                  CLEAR lv_xml.
                  CONCATENATE '<kod>'
                              lv_islem
                              '</kod>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<teslimVeHizmetTutari>'
                              lv_char_amount1
                              '</teslimVeHizmetTutari>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<yuklenilenKDV>'
                              lv_char_amount3
                              '</yuklenilenKDV>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.


                ENDIF.

                IF lv_islem IS NOT INITIAL AND ls_kiril3-kiril1 EQ '019'.

                  CLEAR lv_xml.
                  CONCATENATE '<islemTuru>'
                              lv_islem
                              '</islemTuru>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<teslimVeHizmetTutari>'
                              lv_char_amount1
                              '</teslimVeHizmetTutari>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<yuklenilenKDV>'
                              lv_char_amount3
                              '</yuklenilenKDV>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.


                ENDIF.

                IF ls_kiril3-kiril1 EQ '013'.

                  CLEAR lv_xml.
                  CONCATENATE '<bedel>'
                              lv_char_amount1
                              '</bedel>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.
                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<KDVTutari>'
                              lv_char_amount3
                              '</KDVTutari>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.
                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.


                ENDIF.

                IF NOT ( ls_kiril3-kiril1 EQ '031' OR ls_kiril3-kiril1 EQ '013' ).

                  CLEAR lv_xml.
                  CONCATENATE '<vergi>'
                              lv_char_amount3
                              '</vergi>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.
                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.
                ENDIF.

*                IF ls_kiril3-kiril1 EQ '031'.
*                  CLEAR lv_xml.
*                  CONCATENATE '<tckn>'
*                              lv_ek_tckn
*                              '</tckn>'
*                              INTO lv_xml.
*                  CONDENSE lv_xml NO-GAPS.
*                  CONCATENATE lv_xml_string
*                              lv_xml
*                              INTO lv_xml_string
*                              SEPARATED BY space.
*
*                  CLEAR lv_xml.
*                  CONCATENATE '<unvan>'
*                              lv_ek_unvan
*                              '</unvan>'
*                              INTO lv_xml.
*                  CONDENSE lv_xml NO-GAPS.
*                  CONCATENATE lv_xml_string
*                              lv_xml
*                              INTO lv_xml_string
*                              SEPARATED BY space.
*
*                  CLEAR lv_xml.
*                  CONCATENATE '<faturaBelgeTarihi>'
*                              lv_ek_tarih
*                              '</faturaBelgeTarihi>'
*                              INTO lv_xml.
*                  CONDENSE lv_xml NO-GAPS.
*                  CONCATENATE lv_xml_string
*                              lv_xml
*                              INTO lv_xml_string
*                              SEPARATED BY space.
*
*                  CLEAR lv_xml.
*                  CONCATENATE '<seriNo>'
*                              lv_ek_serino
*                              '</seriNo>'
*                              INTO lv_xml.
*                  CONDENSE lv_xml NO-GAPS.
*                  CONCATENATE lv_xml_string
*                              lv_xml
*                              INTO lv_xml_string
*                              SEPARATED BY space.
*
*                  CLEAR lv_xml.
*                  CONCATENATE '<siraNo>'
*                              lv_ek_sırano
*                              '</siraNo>'
*                              INTO lv_xml.
*                  CONDENSE lv_xml NO-GAPS.
*                  CONCATENATE lv_xml_string
*                              lv_xml
*                              INTO lv_xml_string
*                              SEPARATED BY space.
*                ENDIF.

                IF lv_islem IS NOT INITIAL AND ls_kiril3-kiril1 EQ '034'.
                  CLEAR lv_indirim_tur.
                  lv_indirim_tur = lv_islem.
                  SHIFT lv_indirim_tur LEFT DELETING LEADING '0'.
                  CLEAR lv_xml.
                  CONCATENATE '<indirimNedenTur>'
                              lv_indirim_tur
                              '</indirimNedenTur>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.
                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.

                  CLEAR lv_xml.
                  CONCATENATE '<indirimMiktar>'
                              lv_char_amount3
                              '</indirimMiktar>'
                              INTO lv_xml.
                  CONDENSE lv_xml NO-GAPS.
                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.
                ENDIF.


                READ TABLE lt_bxmls_desc INTO ls_bxmls_desc WITH KEY kiril1 = ls_kiril1-kiril1.
                IF sy-subrc IS INITIAL.

                  CLEAR lv_xml.
                  CONCATENATE '</'
                              ls_bxmls_desc-xmlacklm
                              '>'
                              INTO lv_xml.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.


                ENDIF.

              ENDLOOP.
              IF sy-subrc IS INITIAL.
                lv_kiril3_loop = abap_true.
              ELSEIF sy-subrc IS NOT INITIAL.

                READ TABLE lt_bxmls_desc INTO ls_bxmls_desc WITH KEY kiril1 = ls_kiril1-kiril1.
                IF sy-subrc IS INITIAL.
                  CLEAR lv_xml.
                  CONCATENATE '<'
                              ls_bxmls_desc-xmlacklm
                              '>'
                              INTO lv_xml.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.
                ENDIF.


                CLEAR lv_xml.
                CLEAR lv_char_amount1.
                CLEAR lv_char_amount2.
                CLEAR lv_char_amount3.


                lv_char_amount1 = ls_kiril2-matrah.
                lv_char_amount2 = ls_kiril2-oran.
                lv_char_amount3 = ls_kiril2-vergi.
                SHIFT lv_char_amount1 LEFT DELETING LEADING space.
                SHIFT lv_char_amount2 LEFT DELETING LEADING space.
                SHIFT lv_char_amount3 LEFT DELETING LEADING space.

                CLEAR lv_xml.
                CONCATENATE '<matrah>'
                            lv_char_amount1
                            '</matrah>'
                            INTO lv_xml.
                CONDENSE lv_xml NO-GAPS.
                CONCATENATE lv_xml_string
                            lv_xml
                            INTO lv_xml_string
                            SEPARATED BY space.

                CLEAR lv_xml.
                CONCATENATE '<oran>'
                            lv_char_amount2
                            '</oran>'
                            INTO lv_xml.
                CONDENSE lv_xml NO-GAPS.
                CONCATENATE lv_xml_string
                            lv_xml
                            INTO lv_xml_string
                            SEPARATED BY space.

                CLEAR lv_xml.
                CONCATENATE '<vergi>'
                            lv_char_amount1
                            '</vergi>'
                            INTO lv_xml.
                CONDENSE lv_xml NO-GAPS.
                CONCATENATE lv_xml_string
                            lv_xml
                            INTO lv_xml_string
                            SEPARATED BY space.

                READ TABLE lt_bxmls_desc INTO ls_bxmls_desc WITH KEY kiril1 = ls_kiril1-kiril1.
                IF sy-subrc IS INITIAL.

                  CLEAR lv_xml.
                  CONCATENATE '</'
                              ls_bxmls_desc-xmlacklm
                              '>'
                              INTO lv_xml.

                  CONCATENATE lv_xml_string
                              lv_xml
                              INTO lv_xml_string
                              SEPARATED BY space.


                ENDIF.
*<<Alper NANTU 019 XML hatası için commmentlendi.
*                CLEAR lv_xml.
*                READ TABLE lt_bxmls INTO ls_bxmls WITH KEY kiril1 = ls_kiril1-kiril1.
*                IF sy-subrc IS INITIAL.
*                  CLEAR lv_xml.
*                  CONCATENATE '</'
*                  ls_bxmls-xmlacklm
*                  '>'
*                  INTO lv_xml.
*
*                  CONCATENATE lv_xml_string
*                              lv_xml
*                              INTO lv_xml_string
*                              SEPARATED BY space.
*                ENDIF.
*>>Alper NANTU 019
              ENDIF.

            ENDLOOP.
            IF lv_kiril3_loop EQ abap_true.
              CLEAR lv_xml.
              READ TABLE lt_bxmls INTO ls_bxmls WITH KEY kiril1 = ls_kiril1-kiril1.
              IF sy-subrc IS INITIAL.
                CLEAR lv_xml.
                CONCATENATE '</'
                ls_bxmls-xmlacklm
                '>'
                INTO lv_xml.

                CONCATENATE lv_xml_string
                            lv_xml
                            INTO lv_xml_string
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
      IF ls_bxmls_gk1-kiril1 EQ '031'.
        CLEAR lv_xml.
        CONCATENATE '</'
        'ekler'
        '>'
        INTO lv_xml.

        CONCATENATE lv_xml_string
                    lv_xml
                    INTO lv_xml_string
                    SEPARATED BY space.

      ENDIF.
    ENDLOOP.

    CONCATENATE lv_xml_string
                '</ozel>'
                INTO lv_xml_string
                SEPARATED BY space.

    CONCATENATE lv_xml_string
                '</beyanname>'
                INTO lv_xml_string
                SEPARATED BY space.

    CLEAR lv_filename.
    CONCATENATE lv_dyolu
                lv_beyanv
                '.xml'
                INTO lv_filename.

    IF lv_xml_string IS NOT INITIAL.
      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).

          DATA(lv_username) = cl_abap_context_info=>get_user_technical_name(  ).

          SELECT SINGLE defaultemailaddress
   FROM i_businessuservh WHERE userid = @lv_username
   INTO @DATA(lv_email).

          lo_mail->set_sender( iv_address    = CONV #( lv_email ) ).
          lo_mail->add_recipient( iv_address = CONV #( lv_email ) ).


          DATA(lv_subject) = |Beyanname;|.
          DATA(lv_content) = |{ lv_xml_string }|.

          lo_mail->set_subject( CONV #( lv_subject ) ).
          lo_mail->set_main( cl_bcs_mail_textpart=>create_instance( iv_content      = lv_content
                                                                    iv_content_type = 'application/xml; charset=UTF-8'
                                                                    iv_filename     = 'beyanname.txt' ) ).
          lo_mail->send( IMPORTING et_status = DATA(lt_status) ).

          READ ENTITIES OF ztax_ddl_i_vat1_dec_report IN LOCAL MODE
                 ENTITY ztax_ddl_i_vat1_dec_report
                 FROM CORRESPONDING #( keys )
                 RESULT DATA(found_data).

          LOOP AT found_data INTO DATA(found).

            INSERT VALUE #(
                bukrs     = found-bukrs
                gjahr     = found-gjahr
                monat     = found-monat
                lineitem  = found-lineitem
                %param    = found
            ) INTO TABLE result.

          ENDLOOP.

*          COMMIT WORK.
        CATCH cx_bcs_mail INTO DATA(lo_err).
          DATA(lv_error) = lo_err->get_longtext( ) .
      ENDTRY.
    ENDIF.



  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZTAX_DDL_I_VAT1_DEC_REPORT DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZTAX_DDL_I_VAT1_DEC_REPORT IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
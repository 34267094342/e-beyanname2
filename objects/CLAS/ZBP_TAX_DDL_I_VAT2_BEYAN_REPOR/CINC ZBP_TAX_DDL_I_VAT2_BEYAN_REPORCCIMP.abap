CLASS lhc_ztax_ddl_i_vat2_beyan_repo DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    DATA mt_collect                TYPE TABLE OF ztax_ddl_i_vat2_beyan_report.
    DATA ms_collect                TYPE ztax_ddl_i_vat2_beyan_report.
    DATA mr_monat TYPE RANGE OF monat.

    DATA mt_kesinti                TYPE TABLE OF ztax_ddl_i_vat2_kes_report.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_vat2_beyan_report RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE ztax_ddl_i_vat2_beyan_report.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE ztax_ddl_i_vat2_beyan_report.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE ztax_ddl_i_vat2_beyan_report.

    METHODS read FOR READ
      IMPORTING keys FOR READ ztax_ddl_i_vat2_beyan_report RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ztax_ddl_i_vat2_beyan_report.
    METHODS createxml FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_vat2_beyan_report~createxml RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ztax_ddl_i_vat2_beyan_report RESULT result.

ENDCLASS.

CLASS lhc_ztax_ddl_i_vat2_beyan_repo IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD createxml.

    DATA: lo_vat2_report TYPE REF TO zcl_tax_vat2_beyan_report.
    CREATE OBJECT lo_vat2_report.

    DATA(lt_keys) = keys.

    READ TABLE lt_keys INTO DATA(ls_keys) INDEX 1.
    IF sy-subrc EQ 0.

*
      DATA(p_bukrs) = ls_keys-bukrs.
      DATA(p_gjahr) = ls_keys-gjahr.
      DATA(p_monat) = ls_keys-monat.
      DATA(p_donemb) = 01.
*
*
      CALL METHOD lo_vat2_report->kdv2
        EXPORTING
          iv_bukrs   = p_bukrs
          iv_gjahr   = p_gjahr
          iv_monat   = p_monat
          iv_donemb  = 01
          iv_beyant  = 02
        IMPORTING
          et_collect = mt_collect
          er_monat   = mr_monat.


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

      TYPES: BEGIN OF ty_kesinti_lifnr_sum,
               name1      TYPE  ztax_t_beyg-mad,
               name2      TYPE  ztax_t_beyg-msoyad,
               mcod1      TYPE  c LENGTH 25, "lfa1-mcod1,
               tckn       TYPE  ztax_t_beyg-mvkno,
               vkn        TYPE  ztax_t_beyg-mtckn,
               mwskz      TYPE mwskz,
               islem_tur  TYPE  ztax_e_islem_tur,
               matrah     TYPE  ztax_e_matrah,
               oran       TYPE  ztax_ddl_i_vat2_beyan_report-oran,
               vergi      TYPE  ztax_e_vergi,
               tevkt      TYPE  ztax_e_tevkifat,
               tevkt_oran TYPE  ztax_ddl_i_vat2_beyan_report-tevkifato,
               odmtr      TYPE ztax_e_odeme_turu,

*             kiril2 TYPE  /itetr/tax_s_kesinti-kiril2,
             END OF ty_kesinti_lifnr_sum.
      DATA lt_kesinti_lifnr_sum TYPE TABLE OF ty_kesinti_lifnr_sum.

      TYPES BEGIN OF lty_collect.
      TYPES kiril1    TYPE ztax_t_kdv2g-kiril1.
      TYPES acklm1    TYPE ztax_t_k2k1-acklm.
      TYPES kiril2    TYPE ztax_t_kdv2g-kiril2.
      TYPES acklm2    TYPE ztax_t_k2k2-acklm.
      TYPES kiril3    TYPE val_text."dd07t-ddtext.
      TYPES matrah    TYPE ztax_ddl_i_vat2_kes_report-matrah.
      TYPES oran      TYPE c LENGTH 10.
      TYPES tevkifat  TYPE ztax_ddl_i_vat2_kes_report-tevkt.
      TYPES tevkifato TYPE c LENGTH 10.
      TYPES vergi     TYPE ztax_ddl_i_vat2_kes_report-vergi.
      TYPES field_com(200) TYPE c.
      TYPES END OF lty_collect.

      DATA lv_donem_txt(30).
      DATA lv_value(100).
      DATA lv_beyanv        TYPE ztax_t_beyv-beyanv.
      DATA lv_dyolu         TYPE ztax_t_beydy-dyolu.
      DATA ls_beyg          TYPE lty_beyg.
      DATA lv_monat         TYPE monat.
      DATA lv_xml_string    TYPE string.
      DATA lv_xml           TYPE string.
      DATA lv_char_amount1  TYPE string.
      DATA lv_char_amount2  TYPE string.
      DATA lv_char_amount3  TYPE string.
      DATA lt_kiril1        TYPE TABLE OF ztax_ddl_i_vat2_beyan_report.
      DATA lt_kiril2        TYPE TABLE OF ztax_ddl_i_vat2_beyan_report.
      DATA lt_kiril3        TYPE TABLE OF ztax_ddl_i_vat2_beyan_report.
      DATA ls_kiril1        TYPE ztax_ddl_i_vat2_beyan_report.
      DATA ls_kiril2        TYPE ztax_ddl_i_vat2_beyan_report.
      DATA ls_kiril3        TYPE ztax_ddl_i_vat2_beyan_report.
      DATA lv_kodver        TYPE string.
      DATA lv_nonamespace   TYPE string.
      DATA lv_xmlstring     TYPE string.
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
      DATA lv_mcod1         TYPE string.
      DATA lv_kesinti_vergino TYPE string.
      DATA lv_islemtur      TYPE string.
      DATA lv_oran          TYPE string.
      DATA lv_tevkf_oran    TYPE string.
      DATA lv_filename      TYPE string.
*      DATA lt_x             TYPE mtty_x.
      DATA lv_size          TYPE i.
      DATA lv_tabix         TYPE sy-tabix.
*      DATA lt_hsv_val       TYPE mtty_dd07v.
*      DATA ls_hsv_val       TYPE dd07v.
      DATA lv_char_matrah   TYPE string.
      DATA lv_char_tevkifat TYPE string.
      DATA lv_char_vergino  TYPE string.
      DATA lv_char_tckno    TYPE string.
      DATA lv_kiril3_loop(1).


      FIELD-SYMBOLS <fs>       TYPE any.
      FIELD-SYMBOLS <fs_value> TYPE any.

      READ TABLE mr_monat ASSIGNING <fs> INDEX 1.
      IF <fs> IS ASSIGNED.
        ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs> TO <fs_value>.
        IF <fs_value> IS ASSIGNED.
          lv_monat = <fs_value>.
          UNASSIGN <fs_value>.
        ENDIF.
        UNASSIGN <fs>.
      ENDIF.

*      me->doma_get_value( EXPORTING iv_domain_name = '/ITETR/TAX_HSV'
*                          IMPORTING et_dom_value   = lt_hsv_val ).


      CASE p_donemb.
        WHEN '01'.
          lv_donem_txt = 'aylik'."TEXT-d01.
        WHEN '02'.
          lv_donem_txt = '3 aylik'."TEXT-d02.
      ENDCASE.

      SELECT SINGLE
             bukrs,
             vdkod,
             mvkno,
             mtckn,
             msoyad,
             mad,
             memail,
             malkod,
             mtelno,
             hsvvkn,
             hsv,
             hsvtckn,
             hsvemail,
             hsvakod,
             hsvtelno,
             dvkno,
             dtckn,
             dsoyad,
             dad,
             demail,
             dalkod,
             dtelno,
             tsicil

             FROM ztax_t_beyg
             WHERE bukrs EQ @p_bukrs
             INTO @ls_beyg.

      SELECT SINGLE beyanv
             FROM ztax_t_beyv
             WHERE beyant EQ '02'
             INTO @lv_beyanv.

      SELECT SINGLE dyolu
             FROM ztax_t_beydy
             WHERE bukrs EQ @p_bukrs
               AND beyant EQ '02'
               INTO @lv_dyolu.


      lt_kiril1 = mt_collect.
      lt_kiril2 = mt_collect.
      lt_kiril3 = mt_collect.

      SORT lt_kiril1 BY kiril1 ASCENDING kiril2 ASCENDING.
      DELETE lt_kiril2 WHERE kiril3 NE space OR kiril2 EQ '000'.
      SORT lt_kiril2 BY kiril1 kiril2.

      DELETE ADJACENT DUPLICATES FROM lt_kiril1 COMPARING kiril1.
      DELETE ADJACENT DUPLICATES FROM lt_kiril2 COMPARING kiril1 kiril2.
      DELETE lt_kiril3 WHERE kiril3 EQ space.

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
                  lv_monat
                  '</ay>'
                  INTO lv_ay.

      CONCATENATE '<vergiNo>'
                   ls_beyg-mvkno
                   '</vergiNo>'
                  INTO lv_mvergino.

      CONCATENATE '<tcKimlikNo>'
                  ls_beyg-mtckn
                  '</tcKimlikNo>'
                  INTO lv_mtckimlikno.

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

*      CLEAR ls_hsv_val.
*      READ TABLE lt_hsv_val INTO ls_hsv_val WITH KEY domvalue_l = ls_beyg-hsv.

      CONCATENATE '<hsv sifat="'
*                  ls_hsv_val-ddtext
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

      CONCATENATE '<tcKimlikNo>'
                  ls_beyg-dtckn
                  '</tcKimlikNo>'
                  INTO lv_dtckimlikno.

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

      " loop at xml için


      LOOP AT lt_kiril1 INTO ls_kiril1 WHERE kiril1 NE '000'.
        CASE ls_kiril1-kiril1.
          WHEN '001'.
            CONCATENATE lv_xml_string
                        '<tamtevkifatlılar>'
                        INTO lv_xml_string
                        SEPARATED BY space.
          WHEN OTHERS.
            CONCATENATE lv_xml_string
                        '<tevkifatUygulananlar>'  "'<tevkifatuygulanmayanlar>'
                        INTO lv_xml_string
                        SEPARATED BY space.
        ENDCASE.

        LOOP AT lt_kiril2 INTO ls_kiril2 WHERE kiril1 EQ ls_kiril1-kiril1.


          LOOP AT lt_kiril3 INTO ls_kiril3 WHERE kiril1 EQ ls_kiril1-kiril1
                                             AND kiril2 EQ ls_kiril2-kiril2.
*        READ TABLE lt_kiril3 INTO ls_kiril3 WITH KEY kiril1 = ls_kiril1-kiril1
*                                                     kiril2 = ls_kiril2-kiril2.

            IF ls_kiril3-matrah   EQ '0.00' AND ls_kiril3-vergi EQ '0.00' AND
               ls_kiril3-tevkifat EQ '0.00'.

              CONTINUE.
            ENDIF.

            CASE ls_kiril3-kiril1.
              WHEN '001'.
                CONCATENATE lv_xml_string
                            '<tamtevkifat>'
                            INTO lv_xml_string
                            SEPARATED BY space.
              WHEN OTHERS.
                CONCATENATE lv_xml_string
                            '<tevkifatUygulanan>'
                            INTO lv_xml_string
                            SEPARATED BY space.
            ENDCASE.


            CONDENSE ls_kiril3-kiril2.
            CONCATENATE lv_xml_string
                        '<islemTuru>'
                        ls_kiril3-kiril2
                        '</islemTuru>'
                        INTO lv_xml_string.
*                        SEPARATED BY space.

            CLEAR lv_char_amount1.
            CLEAR lv_char_amount2.
            CLEAR lv_char_amount3.

            lv_char_amount1 = ls_kiril3-matrah.
            lv_char_amount2 = ls_kiril3-vergi.
            lv_char_amount3 = ls_kiril3-tevkifat.
            SHIFT lv_char_amount1 LEFT DELETING LEADING space.
            SHIFT lv_char_amount2 LEFT DELETING LEADING space.
            SHIFT lv_char_amount3 LEFT DELETING LEADING space.


            CONDENSE  lv_char_amount1.
            CONCATENATE lv_xml_string
                        '<matrah>'
                        lv_char_amount1
                        '</matrah>'
                        INTO lv_xml_string.
*                        SEPARATED BY space.

            CONDENSE ls_kiril3-oran.
            CONCATENATE lv_xml_string
                        '<oran>'
                         ls_kiril3-oran
                         '</oran>'
                         INTO lv_xml_string.
*                         SEPARATED BY space.

            CONDENSE ls_kiril3-tevkifato.
            CONCATENATE lv_xml_string
                        '<tevkifatOrani>'
                        ls_kiril3-tevkifato
                        '</tevkifatOrani>'
                        INTO lv_xml_string.
*                        SEPARATED BY space.

            CONDENSE  lv_char_amount3.
            CONCATENATE lv_xml_string
                        '<vergi>'
                        lv_char_amount3
                        '</vergi>'
                        INTO lv_xml_string.
*                        SEPARATED BY space.

            CASE ls_kiril3-kiril1.
              WHEN '001'.
                CONCATENATE lv_xml_string
                            '</tamtevkifat>'
                            INTO lv_xml_string
                            SEPARATED BY space.
              WHEN OTHERS.
                CONCATENATE lv_xml_string
                            '</tevkifatUygulanan>'
                            INTO lv_xml_string
                            SEPARATED BY space.
            ENDCASE.


          ENDLOOP.

        ENDLOOP.
        CASE ls_kiril1-kiril1.
          WHEN '001'.
            CONCATENATE lv_xml_string
                        '</tamtevkifatlılar>'
                        INTO lv_xml_string
                        SEPARATED BY space.
          WHEN OTHERS.
            CONCATENATE lv_xml_string
                        '</tevkifatUygulananlar>'
                        INTO lv_xml_string
                        SEPARATED BY space.
        ENDCASE.
      ENDLOOP.

      DATA: lo_vat2_kesinti TYPE REF TO zcl_tax_vat2_kes_report.
      CREATE OBJECT lo_vat2_kesinti.

      lt_keys = keys.

      READ TABLE lt_keys INTO ls_keys INDEX 1.
      IF sy-subrc EQ 0.

*
        p_bukrs = ls_keys-bukrs.
        p_gjahr = ls_keys-gjahr.
        p_monat = ls_keys-monat.
*
      ENDIF.

      CALL METHOD lo_vat2_kesinti->get_data
        EXPORTING
          iv_bukrs  = p_bukrs
          iv_gjahr  = p_gjahr
          iv_monat  = p_monat
          iv_donemb = 1
        IMPORTING
          et_result = mt_kesinti.
      "monat seçim kriterlerinde kale alınmadığı için burada ilgili döneme ait olmayan kayıtlar siliniyor. Çağatay-Sümeyye
      DELETE mt_kesinti WHERE monat <> p_monat.
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

      DATA(ls_lifnr_sum_kesinti) = VALUE ty_kesinti_lifnr_sum( ).

      LOOP AT mt_kesinti INTO DATA(ls_kesinti).
        MOVE-CORRESPONDING ls_kesinti TO ls_lifnr_sum_kesinti.
        COLLECT ls_lifnr_sum_kesinti INTO lt_kesinti_lifnr_sum.
      ENDLOOP.

      CONCATENATE lv_xml_string
                '<kesintiler>'
                INTO lv_xml_string
                SEPARATED BY space.
      SORT lt_kesinti_lifnr_sum ASCENDING BY mcod1.
      LOOP AT lt_kesinti_lifnr_sum INTO ls_lifnr_sum_kesinti.

        CONCATENATE lv_xml_string
                    '<kesinti>'
                    INTO lv_xml_string
                    SEPARATED BY space.

        CLEAR: lv_char_matrah , lv_char_tevkifat.
        lv_char_matrah   = ls_lifnr_sum_kesinti-matrah.
        lv_char_tevkifat = ls_lifnr_sum_kesinti-tevkt.

        CLEAR : lv_kesinti_vergino , lv_char_tckno , lv_char_vergino.
        IF ls_lifnr_sum_kesinti-tckn IS NOT INITIAL.
          lv_char_tckno    = ls_lifnr_sum_kesinti-tckn.
        ENDIF.
        IF ls_lifnr_sum_kesinti-vkn IS NOT INITIAL.
          lv_char_vergino  = ls_lifnr_sum_kesinti-vkn.
        ENDIF.

        CONCATENATE '<soyadi>'
                    ls_lifnr_sum_kesinti-name1
                    '</soyadi>'
                    INTO lv_mcod1.
        IF lv_char_vergino IS NOT INITIAL.
          CONCATENATE '<vergiNo>'
                      lv_char_vergino
                      '</vergiNo>'
                      INTO lv_kesinti_vergino.
        ENDIF.
        IF lv_char_tckno IS NOT INITIAL.
          CONCATENATE '<tcKimlikNo>'
                      lv_char_tckno
                      '</tcKimlikNo>'
                      INTO lv_kesinti_vergino.
        ENDIF.

        CONCATENATE '<islemTuru>'"<<Alper NANTU 07.12.2025
                    ls_lifnr_sum_kesinti-islem_tur
                    '</islemTuru>'">> Alper NANTU 07.12.2025
                    INTO lv_islemtur.

        CLEAR ms_collect.
        READ TABLE mt_collect INTO ms_collect WITH KEY kiril2 = ls_lifnr_sum_kesinti-islem_tur
                                                       kiril3 = ls_lifnr_sum_kesinti-mwskz.
        lv_oran       = ms_collect-oran.
        lv_tevkf_oran = ms_collect-tevkifato.

        CONDENSE lv_oran NO-GAPS.
        CONDENSE lv_tevkf_oran NO-GAPS.
        condeNSE lv_char_matrah no-GAPS.
        condeNSE lv_tevkf_oran no-GAPS.
        condeNSE lv_char_tevkifat no-GAPS.
        cl_abap_string_utilities=>del_trailing_blanks( CHANGING str = lv_char_matrah ).
        CONCATENATE lv_xml_string
                    lv_mcod1
                    lv_kesinti_vergino
                    lv_islemtur
                    '<vergiyeTabiMatrah>' lv_char_matrah '</vergiyeTabiMatrah>'
                    '<oran>20</oran>'
                    '<tevkifatOrani>' lv_tevkf_oran '</tevkifatOrani>'
                    '<tutar>' lv_char_tevkifat '</tutar>'
                    '<odemeTuru>102</odemeTuru>'
                    INTO lv_xml_string.

        CONCATENATE lv_xml_string
                    '</kesinti>'
                    INTO lv_xml_string
                    SEPARATED BY space.

      ENDLOOP.

      CONCATENATE lv_xml_string
                  '</kesintiler>'
                  INTO lv_xml_string
                  SEPARATED BY space.


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


    ENDIF.

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

*          COMMIT WORK.
        CATCH cx_bcs_mail INTO DATA(lo_err).
          DATA(lv_error) = lo_err->get_longtext( ) .
      ENDTRY.
    ENDIF.



  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ztax_ddl_i_vat2_beyan_repo DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ztax_ddl_i_vat2_beyan_repo IMPLEMENTATION.

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
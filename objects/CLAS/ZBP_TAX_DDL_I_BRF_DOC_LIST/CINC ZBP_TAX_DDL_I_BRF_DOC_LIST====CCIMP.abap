CLASS lhc_ZTAX_DDL_I_BRF_DOC_LIST DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    TYPES mty_x(256)    TYPE x.
    TYPES mtty_x        TYPE TABLE OF mty_x.

    TYPES BEGIN OF mty_ode_smpl.
    TYPES belnr  TYPE ztax_s_muh_ode-belnr.
    TYPES gjahr  TYPE ztax_s_muh_ode-gjahr.
    TYPES lifnr  TYPE ztax_s_muh_ode-lifnr.
    TYPES name2  TYPE ztax_s_muh_ode-name2.
    TYPES name1  TYPE ztax_s_muh_ode-name1.
    TYPES adres  TYPE ztax_s_muh_ode-adres.
    TYPES tckn   TYPE ztax_s_muh_ode-tckn.
    TYPES vkn    TYPE ztax_s_muh_ode-vkn.
    TYPES mindk  TYPE ztax_s_muh_ode-mindk.
    TYPES mtext  TYPE ztax_s_muh_ode-mtext.
    TYPES budat  TYPE ztax_s_muh_ode-budat.
    TYPES xblnr  TYPE ztax_s_muh_ode-xblnr.
    TYPES beltr  TYPE ztax_s_muh_ode-beltr.
    TYPES beltrx TYPE ztax_s_muh_ode-beltrx.
    TYPES gyst   TYPE ztax_s_muh_ode-gyst.
    TYPES kst    TYPE ztax_s_muh_ode-kst.
    TYPES sosg   TYPE ztax_s_muh_ode-sosg.
*    TYPES row_color TYPE /itetr/tax_s_muh_ode-row_color.
    TYPES END OF mty_ode_smpl.

    TYPES mtty_ode     TYPE TABLE OF ztax_ddl_i_brf_payments.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ztax_ddl_i_brf_doc_list RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_brf_doc_list RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ ztax_ddl_i_brf_doc_list RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ztax_ddl_i_brf_doc_list.

    METHODS CreateXml FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_brf_doc_list~CreateXml RESULT result.

ENDCLASS.

CLASS lhc_ZTAX_DDL_I_BRF_DOC_LIST IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD CreateXml.


    DATA(lt_keys) = keys.

    READ TABLE lt_keys INTO DATA(ls_keys) INDEX 1.
    IF sy-subrc EQ 0.

*
      DATA(p_bukrs) = ls_keys-bukrs.
      DATA(p_gjahr) = ls_keys-gjahr.
      DATA(p_monat) = ls_keys-monat.
      DATA(p_donemb) = 01.
    ENDIF.

*    TYPES BEGIN OF lty_beyg.
*    TYPES bukrs    TYPE ztax_T_beyg-bukrs.
*    TYPES vdkod    TYPE ztax_T_beyg-vdkod.
*    TYPES mvkno    TYPE ztax_T_beyg-mvkno.
*    TYPES mtckn    TYPE ztax_T_beyg-mtckn.
*    TYPES msoyad   TYPE ztax_T_beyg-msoyad.
*    TYPES mad      TYPE ztax_T_beyg-mad.
*    TYPES memail   TYPE ztax_T_beyg-memail.
*    TYPES malkod   TYPE ztax_T_beyg-malkod.
*    TYPES mtelno   TYPE ztax_T_beyg-mtelno.
*    TYPES hsvvkn   TYPE ztax_T_beyg-hsvvkn.
*    TYPES hsv      TYPE ztax_T_beyg-hsv.
*    TYPES hsvtckn  TYPE ztax_T_beyg-hsvtckn.
*    TYPES hsvemail TYPE ztax_T_beyg-hsvemail.
*    TYPES hsvakod  TYPE ztax_T_beyg-hsvakod.
*    TYPES hsvtelno TYPE ztax_T_beyg-hsvtelno.
*    TYPES dvkno    TYPE ztax_T_beyg-dvkno.
*    TYPES dtckn    TYPE ztax_T_beyg-dtckn.
*    TYPES dsoyad   TYPE ztax_T_beyg-dsoyad.
*    TYPES dad      TYPE ztax_T_beyg-dad.
*    TYPES demail   TYPE ztax_T_beyg-demail.
*    TYPES dalkod   TYPE ztax_T_beyg-dalkod.
*    TYPES dtelno   TYPE ztax_T_beyg-dtelno.
*    TYPES END OF lty_beyg.

    DATA lv_donem_txt(30).
    DATA lv_value(100).
    DATA lv_beyanv        TYPE ztax_t_beyv-beyanv.
    DATA lv_dyolu         TYPE ztax_T_beydy-dyolu.
    DATA ls_beyg          TYPE ztax_t_beyg.
    DATA lv_monat         TYPE monat.
    DATA lv_xml_string    TYPE string.
    DATA lv_xml           TYPE string.
    DATA lv_char_amount1  TYPE string.
    DATA lv_char_amount2  TYPE string.
    DATA lv_char_amount3  TYPE string.
    DATA lt_kiril1        TYPE TABLE OF ztax_ddl_i_brf_doc_list.
    DATA lt_kiril2        TYPE TABLE OF ztax_ddl_i_brf_doc_list.
    DATA lt_kiril3        TYPE TABLE OF ztax_ddl_i_brf_doc_list.
    DATA ls_kiril1        TYPE ztax_ddl_i_brf_doc_list.
    DATA ls_kiril2        TYPE ztax_ddl_i_brf_doc_list.
    DATA ls_kiril3        TYPE ztax_ddl_i_brf_doc_list.


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
    DATA lv_filename      TYPE string.
*    DATA lv_tic_sicil_no  TYPE string.
    DATA lv_tsicil        TYPE string.
    DATA lt_x             TYPE mtty_x.
    DATA lv_size          TYPE i.
    DATA lv_tabix         TYPE sy-tabix.
*    DATA lt_hsv_val       TYPE mtty_domain.
    DATA ls_hsv_val       TYPE string.
    DATA lv_kiril3_loop(1).
    DATA ls_isy           TYPE ztax_t_isy.
    DATA ls_tscm          TYPE ztax_t_tscm.
    DATA ls_ode           TYPE ztax_ddl_i_brf_payments.
    DATA ls_gricd         TYPE Ztax_ddl_i_brf_payments.
    DATA ls_ode_smpl      TYPE ztax_ddl_i_brf_payments."mty_ode_smpl.
    DATA lt_ode_smpl      TYPE TABLE OF ztax_ddl_i_brf_payments."mty_ode_smpl.
    DATA lt_gricd         TYPE mtty_ode.
    DATA lv_turkod(3)     TYPE n.

    DATA lv_total1 TYPE ztax_s_muh_ode-gyst.
    DATA lv_total2 TYPE ztax_s_muh_ode-gyst.
    DATA lv_total3 TYPE ztax_s_muh_ode-gyst.
    DATA lv_total4 TYPE ztax_s_muh_ode-gyst.
    DATA lv_total1_char(20).
    DATA lv_total2_char(20).
    DATA lv_isyadrno(20).

    DATA lt_ode TYPE mtty_ode.

    FIELD-SYMBOLS <fs>       TYPE any.
    FIELD-SYMBOLS <fs_value> TYPE any.

    DATA mt_ode         TYPE mtty_ode.



*    READ TABLE mr_monat ASSIGNING <fs> INDEX 1.
*    IF <fs> IS ASSIGNED.
*      ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs> TO <fs_value>.
*      IF <fs_value> IS ASSIGNED.
*        lv_monat = <fs_value>.
*        UNASSIGN <fs_value>.
*      ENDIF.
*      UNASSIGN <fs>.
*    ENDIF.

*    me->domain_read( EXPORTING iv_domain_name = '/ITETR/TAX_HSV'
*                     IMPORTING et_domain      = lt_hsv_val ).

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
           WHERE beyant EQ '03'
           INTO @lv_beyanv.

*      SELECT SINGLE dyolu
*             FROM ztax_t_beydy
*             WHERE bukrs EQ @p_bukrs
*               AND beyant EQ '03'
*               INTO @lv_dyolu.

    SELECT SINGLE *
        FROM ztax_T_isy
        WHERE bukrs EQ @p_bukrs
                INTO @ls_isy.


    SELECT  *
        FROM ztax_T_isy
        WHERE bukrs EQ @p_bukrs
        INTO TABLE @DATA(lt_isy).

    SELECT SINGLE *
        FROM ztax_T_tscm
        WHERE tscm EQ @ls_isy-tscm
        INTO @ls_tscm.


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

    IF ls_beyg-mvkno IS NOT INITIAL.

      CONCATENATE '<vergiNo>'
                   ls_beyg-mvkno
                   '</vergiNo>'
                  INTO lv_mvergino.

    ENDIF.

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
*
*    CONCATENATE '<ticSicilNo>'
*                ls_isy-isyscno
*                '</ticSicilNo>'
*                INTO lv_tic_sicil_no.

    CONCATENATE '<ticSicilNo>'
                ls_beyg-tsicil
                '</ticSicilNo>'
                INTO lv_tsicil.

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

    CLEAR ls_hsv_val.
*    READ TABLE lt_hsv_val INTO ls_hsv_val WITH KEY domvalue_l = ls_beyg-hsv.
*

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

    CONCATENATE '<ticSicilNo>'
                ls_beyg-tsicil
                '</ticSicilNo>'
                INTO lv_tsicil.


    IF ls_beyg-hsvvkn IS NOT INITIAL.

      CONCATENATE '<vergiNo>'
                   ls_beyg-hsvvkn
                  '</vergiNo>'
                  INTO lv_hsvvergino.

    ENDIF.

    IF ls_beyg-hsvtckn IS NOT INITIAL.

      CONCATENATE '<tcKimlikNo>'
                  ls_beyg-hsvtckn
                  '</tcKimlikNo>'
                  INTO lv_hsvtckimlikno.

    ENDIF.

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

    IF ls_beyg-dvkno IS NOT INITIAL.
      CONCATENATE '<vergiNo>'
                  ls_beyg-dvkno
                  '</vergiNo>'
                  INTO lv_dvergino.
    ENDIF.

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
                lv_tsicil
                lv_meposta
                lv_malankodu
                lv_mtelno
                '</mukellef>'
                lv_hsv
                lv_hsvsoyadi
                lv_hsvadi
                lv_tsicil
                lv_hsvvergino
                lv_hsvtckimlikno
                lv_hsveposta
                lv_hsvalankodu
                lv_hsvtelno
                '</hsv>'
                '<duzenleyen>'
                lv_dvergino
                lv_dtckimlikno
                lv_dsoyadi
                lv_dadi
                lv_tsicil
                lv_deposta
                lv_dalankodu
                lv_dtelno
                '</duzenleyen>'
                '</genel>'
                '<ozel>'
                '<subeNo>0</subeNo>'
                '<beyanimVarYok>1</beyanimVarYok>'
                '<matrahBildirimleri>'
                INTO lv_xml_string
                SEPARATED BY space.
    "<-

    CLEAR lt_ode.
*    me->get_payments( IMPORTING et_ode = lt_ode ).


    DATA: lo_brf_payments TYPE REF TO zcl_tax_brf_payments.
    CREATE OBJECT lo_brf_payments.



*
*
    CALL METHOD lo_brf_payments->get_payments
      EXPORTING
        iv_bukrs  = p_bukrs
        iv_gjahr  = p_gjahr
        iv_monat  = p_monat
        iv_donemb = 01
      IMPORTING
        et_ode    = lt_ode.



    LOOP AT lt_ode INTO ls_ode.
      CLEAR ls_ode_smpl.
      MOVE-CORRESPONDING ls_ode TO ls_ode_smpl.
      CLEAR ls_ode_smpl-belnr.
      CLEAR ls_ode_smpl-gjahr.
      COLLECT ls_ode_smpl INTO lt_ode_smpl.
      CLEAR ls_ode_smpl.
    ENDLOOP.

    MOVE-CORRESPONDING lt_ode_smpl[] TO mt_ode[].

    lt_gricd = mt_ode.
    SORT lt_gricd BY mindk.
    DELETE ADJACENT DUPLICATES FROM lt_gricd COMPARING mindk.


    SORT mt_ode BY mindk.

    CLEAR lv_total3.
    CLEAR lv_total4.

    LOOP AT lt_gricd INTO ls_gricd.
      CLEAR lv_total1.
      CLEAR lv_total2.
      CLEAR lv_total1_char.
      CLEAR lv_total2_char.
      lv_turkod = ls_gricd-mindk.
      READ TABLE mt_ode TRANSPORTING NO FIELDS WITH KEY mindk = ls_gricd-mindk BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        LOOP AT mt_ode INTO ls_ode FROM sy-tabix.
          IF ls_ode-mindk NE ls_gricd-mindk.
            EXIT.
          ENDIF.
          "
          ADD ls_ode-gyst TO lv_total1.
          ADD ls_ode-kst  TO lv_total2.
          "
          ADD ls_ode-gyst TO lv_total3.
          ADD ls_ode-kst  TO lv_total4.
        ENDLOOP.
      ENDIF.

      lv_total1_char = lv_total1.
      lv_total2_char = lv_total2.
      CONDENSE lv_total1_char NO-GAPS.
      CONDENSE lv_total2_char NO-GAPS.

      CONCATENATE lv_xml_string
                  '<matrahBildirimi>'
                  '<turKodu>'
                  lv_turkod
                  '</turKodu>'
                  '<gayrisafiTutar>'
                  lv_total1_char
                  '</gayrisafiTutar>'
                  '<kesintiTutari>'
                  lv_total2_char
                  '</kesintiTutari>'
                  '</matrahBildirimi>'
                  INTO lv_xml_string.
    ENDLOOP.

    CLEAR lv_total1_char.
    CLEAR lv_total2_char.
    lv_total1_char = lv_total3.
    lv_total2_char = lv_total4.
    CONDENSE lv_total1_char NO-GAPS.
    CONDENSE lv_total2_char NO-GAPS.

    CONCATENATE lv_xml_string
                '</matrahBildirimleri>'
                '<toplamGayrisafiTutar>'
                lv_total1_char
                '</toplamGayrisafiTutar>'
                '<toplamKesintiTutari>'
                lv_total2_char
                '</toplamKesintiTutari>'
                '<terkinSonrasiTutar>'
                lv_total2_char
                '</terkinSonrasiTutar>'
                '<odemeBildirimleri>'
                INTO lv_xml_string.

    SORT mt_ode BY mindk lifnr xblnr budat.

    LOOP AT mt_ode INTO ls_ode.
      CLEAR lv_total1_char.
      CLEAR lv_total2_char.
      lv_turkod = ls_ode-mindk.
      "
      lv_total1_char = ls_ode-gyst.
      lv_total2_char =  ls_ode-kst.
      "
      CONDENSE lv_total1_char NO-GAPS.
      CONDENSE lv_total2_char NO-GAPS.

      CONCATENATE lv_xml_string
      '<odemeBildirimi>'
        '<soyadi>' ls_ode-name1 '</soyadi>'
        '<adi>' ls_ode-name2 '</adi>'
        '<adres>' ls_ode-adres '</adres>'
        INTO lv_xml_string.

      IF ls_ode-tckn IS NOT INITIAL.
        CONCATENATE lv_xml_string
          '<tcKimlikNo>' ls_ode-tckn '</tcKimlikNo>'
          INTO lv_xml_string.
      ENDIF.

      IF ls_ode-vkn IS NOT INITIAL.
        CONCATENATE lv_xml_string
          '<vknNo>' ls_ode-vkn '</vknNo>'
          INTO lv_xml_string.
      ENDIF.

      CONCATENATE lv_xml_string
        '<turKodu>' lv_turkod '</turKodu>'
        '<gayrisafiTutar>' lv_total1_char '</gayrisafiTutar>'
        '<odemeTur>' ls_ode-beltr '</odemeTur>'
        '<odemeTarih>' ls_ode-budat+6(2) ls_ode-budat+4(2) ls_ode-budat+0(4) '</odemeTarih>'
        '<odemeSeriSiraNo>' ls_ode-xblnr '</odemeSeriSiraNo>'
        '<kesintiTutari>' lv_total2_char '</kesintiTutari>'
        '<kdvTevkifati></kdvTevkifati>'
      '</odemeBildirimi>'
      INTO lv_xml_string.

    ENDLOOP.

    CLEAR lv_total1_char.
    CLEAR lv_total2_char.
    lv_total1_char = lv_total3.
    lv_total2_char = lv_total4.
    CONDENSE lv_total1_char NO-GAPS.
    CONDENSE lv_total2_char NO-GAPS.


    CONCATENATE lv_xml_string
                '</odemeBildirimleri>'
                '<matrah>'
                lv_total1_char
                '</matrah>'
                '<tahakkukEden>'
                lv_total2_char
                '</tahakkukEden>'
                '<mahsup>'
                '0.0'
                '</mahsup>'
                '<odenecek>'
                lv_total2_char
                '</odenecek>'
                '<iadeEdilecek>'
                '0.0'
                '</iadeEdilecek>'
                INTO lv_xml_string.

    "->

*    LOOP AT lt_isy INTO ls_isy.
*
*      lv_isyadrno = ls_isy-isyadrno.
*      CONDENSE lv_isyadrno NO-GAPS.
*
*      CONCATENATE lv_xml_string
*                   '<ekler>'
*                    '<isyeriCalisanSGKBilgileri>'
*                      '<calisanlarinIsyeriBilgileri>'
*                        '<calisanlarinIsyeriBilgisi>'
*                          '<isyeriTur>' ls_isy-isytr '</isyeriTur>'
*                          '<isyeriKod>' ls_isy-isykd '</isyeriKod>'
*                          '<ticaretSicilNo>' ls_isy-isyscno '</ticaretSicilNo>'
*                          '<ticaretSicilMudurluk>' ls_isy-tscm '</ticaretSicilMudurluk>'
*                          '<isyeriFaaliyetKod>' ls_isy-isyfkd '</isyeriFaaliyetKod>'
*                          '<isyeriAdi>' ls_isy-isyad '</isyeriAdi>'
*                          '<isyeriAdresNo>' lv_isyadrno '</isyeriAdresNo>'
*                          '<isyeriMulkiyetDurum>' ls_isy-isymlkdr '</isyeriMulkiyetDurum>'
*                        '</calisanlarinIsyeriBilgisi>'
*                      '</calisanlarinIsyeriBilgileri>'
*                    '</isyeriCalisanSGKBilgileri>'
*                  '</ekler>'
*                '</ozel>'
*                  INTO lv_xml_string.
**                SEPARATED BY space.
*
*
*    ENDLOOP.
*
*    CONCATENATE lv_xml_string
*            '</beyanname>'
*            INTO lv_xml_string.
    CONCATENATE lv_xml_string
                '<ekler>'
                '<isyeriCalisanSGKBilgileri>'
                '<calisanlarinIsyeriBilgileri>'
                INTO lv_xml_string.

    " Döngü: sadece <calisanlarinIsyeriBilgisi> kısmı
    LOOP AT lt_isy INTO ls_isy.

      lv_isyadrno = ls_isy-isyadrno.
      CONDENSE lv_isyadrno NO-GAPS.

      CONCATENATE lv_xml_string
                  '<calisanlarinIsyeriBilgisi>'
                    '<isyeriTur>' ls_isy-isytr '</isyeriTur>'
                    '<isyeriKod>' ls_isy-isykd '</isyeriKod>'
                    '<ticaretSicilNo>' ls_isy-isyscno '</ticaretSicilNo>'
                    '<ticaretSicilMudurluk>' ls_isy-tscm '</ticaretSicilMudurluk>'
                    '<isyeriFaaliyetKod>' ls_isy-isyfkd '</isyeriFaaliyetKod>'
                    '<isyeriAdi>' ls_isy-isyad '</isyeriAdi>'
                    '<isyeriAdresNo>' lv_isyadrno '</isyeriAdresNo>'
                    '<isyeriMulkiyetDurum>' ls_isy-isymlkdr '</isyeriMulkiyetDurum>'
                  '</calisanlarinIsyeriBilgisi>'
                  INTO lv_xml_string.

    ENDLOOP.

    " LOOP sonrası kapanış etiketleri
    CONCATENATE lv_xml_string
                '</calisanlarinIsyeriBilgileri>'
                '</isyeriCalisanSGKBilgileri>'
                '</ekler>'
                '</ozel>'
                '</beyanname>'
                INTO lv_xml_string.

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
                                                                    iv_content_type = 'application/xml; encoding="UTF-8"'
                                                                    iv_filename     = 'beyanname.txt' ) ).
          lo_mail->send( IMPORTING et_status = DATA(lt_status) ).

*          COMMIT WORK.
        CATCH cx_bcs_mail INTO DATA(lo_err).
          DATA(lv_error) = lo_err->get_longtext( ) .
      ENDTRY.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZTAX_DDL_I_BRF_DOC_LIST DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZTAX_DDL_I_BRF_DOC_LIST IMPLEMENTATION.

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
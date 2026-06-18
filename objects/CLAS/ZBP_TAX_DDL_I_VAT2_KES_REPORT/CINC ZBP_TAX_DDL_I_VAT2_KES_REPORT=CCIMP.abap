CLASS lhc_ztax_ddl_i_vat2_kes_report DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    TYPES BEGIN OF mty_collect.
    TYPES kiril1    TYPE ztax_t_kdv2g-kiril1.
    TYPES acklm1    TYPE ztax_t_k2k1-acklm.
    TYPES kiril2    TYPE ztax_t_kdv2g-kiril2.
    TYPES acklm2    TYPE ztax_t_k2k2-acklm.
*    TYPES KIRIL3    TYPE DD07T-DDTEXT.
    TYPES matrah    TYPE ztax_e_matrah.
    TYPES oran      TYPE ztax_e_vergi_oran.
    TYPES tevkifat  TYPE ztax_e_tevkifat.
    TYPES tevkifato TYPE ztax_e_tevkifat_oran.
    TYPES vergi     TYPE ztax_e_vergi.
    TYPES field_com(200) TYPE c.
    TYPES END OF mty_collect.

    TYPES mty_x(256)       TYPE x.
    TYPES mtty_x           TYPE TABLE OF mty_x.

*    TYPES MTTY_DD07V       TYPE TABLE OF DD07V.

    DATA mr_monat TYPE RANGE OF monat.

    DATA mt_kesinti                TYPE TABLE OF ztax_ddl_i_vat2_kes_report.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztax_ddl_i_vat2_kes_report RESULT result.

*    METHODS CREATE FOR MODIFY
*      IMPORTING ENTITIES FOR CREATE ZTAX_DDL_I_VAT2_KES_REPORT.
*
*    METHODS UPDATE FOR MODIFY
*      IMPORTING ENTITIES FOR UPDATE ZTAX_DDL_I_VAT2_KES_REPORT.
*
*    METHODS DELETE FOR MODIFY
*      IMPORTING KEYS FOR DELETE ZTAX_DDL_I_VAT2_KES_REPORT.

    METHODS read FOR READ
      IMPORTING keys FOR READ ztax_ddl_i_vat2_kes_report RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ztax_ddl_i_vat2_kes_report.

    METHODS addrecord FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_vat2_kes_report~addrecord RESULT result.

    METHODS deleterecord FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_vat2_kes_report~deleterecord RESULT result.

    METHODS updaterecord FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_vat2_kes_report~updaterecord  RESULT result.

    METHODS createxml FOR MODIFY
      IMPORTING keys FOR ACTION ztax_ddl_i_vat2_kes_report~createxml RESULT result.



ENDCLASS.

CLASS lhc_ztax_ddl_i_vat2_kes_report IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD CREATE.
*  ENDMETHOD.
*
*  METHOD UPDATE.
*  ENDMETHOD.
*
*  METHOD DELETE.
*  ENDMETHOD.

  METHOD read.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD addrecord.
    DATA lt_new_entries TYPE TABLE OF ztax_t_k2mt.
    DATA ls_new_entry TYPE ztax_t_k2mt.
*    CONSTANTS LC_NEW_LINE_BELNR    TYPE I_JOURNALENTRY-AccountingDocument VALUE '**********'.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    CHECK sy-subrc = 0.


    SELECT MAX( buzei )

           FROM ztax_t_k2mt
           WHERE bukrs EQ @ls_key-%param-bukrs
             AND gjahr EQ @ls_key-%param-gjahr
             AND monat EQ @ls_key-%param-monat
             INTO @DATA(lv_buzei).

    lv_buzei = lv_buzei + 1.




    ls_new_entry-bukrs = ls_key-%param-bukrs.
    ls_new_entry-gjahr = ls_key-%param-gjahr.
    ls_new_entry-monat = ls_key-%param-monat.
    ls_new_entry-buzei = lv_buzei."LS_KEY-%PARAM-BUZEI.
    ls_new_entry-tckn = ls_key-%param-tckn.
    ls_new_entry-vkn = ls_key-%param-vkn.
    ls_new_entry-lifnr = ls_key-%param-lifnr.
    ls_new_entry-name1 = ls_key-%param-name1.
    ls_new_entry-name2 = ls_key-%param-name2.
    ls_new_entry-matrah = ls_key-%param-matrah.
    ls_new_entry-vergi = ls_key-%param-vergi.
    ls_new_entry-tevkt = ls_key-%param-tevkt.
    ls_new_entry-mwskz = ls_key-%param-mwskz.
    ls_new_entry-k2type = ls_key-%param-refrection2.
    ls_new_entry-odmtr = ls_key-%param-odmtr.
    ls_new_entry-manuel = ls_key-%param-manuel.
    ls_new_entry-vergidis = ls_key-%param-vergidis.
    ls_new_entry-vergiic = ls_key-%param-vergiic.
*    ls_new_entry-Waers  = 'TRY'.

    APPEND ls_new_entry TO lt_new_entries.

    TRY.


        MODIFY ztax_t_k2mt FROM TABLE @lt_new_entries.

*
      CATCH cx_uuid_error.


    ENDTRY.

  ENDMETHOD.

  METHOD deleterecord.

    TRY.

        READ TABLE keys INTO DATA(ls_key) INDEX 1.
        CHECK sy-subrc = 0.
        DELETE FROM ztax_t_k2mt WHERE bukrs = @ls_key-%param-bukrs
                               AND gjahr = @ls_key-%param-gjahr
                               AND monat = @ls_key-%param-monat
                               AND buzei = @ls_key-%param-buzei.


*
      CATCH cx_uuid_error.


    ENDTRY.


  ENDMETHOD.

  METHOD updaterecord.


    DATA lt_new_entries TYPE TABLE OF ztax_t_k2mt.
    DATA ls_new_entry TYPE ztax_t_k2mt.
*    CONSTANTS LC_NEW_LINE_BELNR    TYPE I_JOURNALENTRY-AccountingDocument VALUE '**********'.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    CHECK sy-subrc = 0.


    SELECT MAX( buzei )
           FROM ztax_t_k2mt
           WHERE bukrs EQ @ls_key-%param-bukrs
             AND gjahr EQ @ls_key-%param-gjahr
             AND monat EQ @ls_key-%param-monat
             INTO @DATA(lv_buzei).


    ls_new_entry-bukrs = ls_key-%param-bukrs.
    ls_new_entry-gjahr = ls_key-%param-gjahr.
    ls_new_entry-monat = ls_key-%param-monat.
    ls_new_entry-buzei = lv_buzei."LS_KEY-%PARAM-BUZEI.
    ls_new_entry-tckn = ls_key-%param-tckn.
    ls_new_entry-vkn = ls_key-%param-vkn.
    ls_new_entry-lifnr = ls_key-%param-lifnr.
    ls_new_entry-name1 = ls_key-%param-name1.
    ls_new_entry-name2 = ls_key-%param-name2.
    ls_new_entry-matrah = ls_key-%param-matrah.
    ls_new_entry-vergi = ls_key-%param-vergi.
    ls_new_entry-tevkt = ls_key-%param-tevkt.
    ls_new_entry-mwskz = ls_key-%param-mwskz.
    ls_new_entry-k2type = ls_key-%param-refrection2.
    ls_new_entry-odmtr = ls_key-%param-odmtr.
    ls_new_entry-manuel = ls_key-%param-manuel.
    ls_new_entry-vergidis = ls_key-%param-vergidis.
    ls_new_entry-vergiic = ls_key-%param-vergiic.
*    ls_new_entry-Waers  = 'TRY'.

    APPEND ls_new_entry TO lt_new_entries.

    TRY.


        MODIFY ztax_t_k2mt FROM TABLE @lt_new_entries.

*
      CATCH cx_uuid_error.


    ENDTRY.

  ENDMETHOD.

  METHOD createxml.


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
    TYPES END OF lty_beyg.

    TYPES BEGIN OF lty_xml_data.
    TYPES lifnr  TYPE ztax_ddl_i_vat2_kes_report-lifnr.
    TYPES name1  TYPE ztax_ddl_i_vat2_kes_report-name1.
    TYPES name2  TYPE ztax_ddl_i_vat2_kes_report-name2.
    TYPES tckn   TYPE ztax_ddl_i_vat2_kes_report-tckn.
    TYPES vkn    TYPE ztax_ddl_i_vat2_kes_report-vkn.
    TYPES matrah TYPE ztax_ddl_i_vat2_kes_report-matrah.
    TYPES tevkt  TYPE ztax_ddl_i_vat2_kes_report-tevkt.
    TYPES odmtr  TYPE ztax_ddl_i_vat2_kes_report-odmtr.
    TYPES END OF lty_xml_data.

    DATA lt_xml_data TYPE TABLE OF lty_xml_data.
    DATA ls_xml_data TYPE lty_xml_data.

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
    DATA lt_kiril1        TYPE TABLE OF mty_collect.
    DATA lt_kiril2        TYPE TABLE OF mty_collect.
    DATA lt_kiril3        TYPE TABLE OF mty_collect.
    DATA ls_kiril1        TYPE mty_collect.
    DATA ls_kiril2        TYPE mty_collect.
    DATA ls_kiril3        TYPE mty_collect.
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
    DATA lt_x             TYPE mtty_x.
    DATA lv_size          TYPE i.
    DATA lv_tabix         TYPE sy-tabix.
*    DATA LT_HSV_VAL       TYPE MTTY_DD07V.
*    DATA LS_HSV_VAL       TYPE DD07V.
    DATA ls_kesinti       TYPE ztax_ddl_i_vat2_kes_report.


    FIELD-SYMBOLS <fs>       TYPE any.
    FIELD-SYMBOLS <fs_value> TYPE any.

**********************************************************************
    DATA: lo_vat2_report TYPE REF TO zcl_tax_vat2_kes_report.
    CREATE OBJECT lo_vat2_report.

    DATA(lt_keys) = keys.

    READ TABLE lt_keys INTO DATA(ls_keys) INDEX 1.
    IF sy-subrc EQ 0.

*
      DATA(p_bukrs) = ls_keys-bukrs.
      DATA(p_gjahr) = ls_keys-gjahr.
      DATA(p_monat) = ls_keys-monat.
      DATA(p_donemb) = 01.



      CALL METHOD lo_vat2_report->get_data
        EXPORTING
          iv_bukrs  = p_bukrs
          iv_gjahr  = p_gjahr
          iv_monat  = p_monat
          iv_donemb = 01
        IMPORTING
          et_result = mt_kesinti.

    ENDIF.




**********************************************************************


    READ TABLE mr_monat ASSIGNING <fs> INDEX 1.
    IF <fs> IS ASSIGNED.
      ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs> TO <fs_value>.
      IF <fs_value> IS ASSIGNED.
        lv_monat = <fs_value>.
        UNASSIGN <fs_value>.
      ENDIF.
      UNASSIGN <fs>.
    ENDIF.

*    ME->DOMA_GET_VALUE( EXPORTING IV_DOMAIN_NAME = '/ITETR/TAX_HSV'
*                        IMPORTING ET_DOM_VALUE   = LT_HSV_VAL ).

    CLEAR lt_xml_data.
    CLEAR ls_xml_data.

    LOOP AT mt_kesinti INTO ls_kesinti.

      CLEAR ls_xml_data.
      ls_xml_data-lifnr   = ls_kesinti-lifnr.
      ls_xml_data-name1   = ls_kesinti-name1.
      ls_xml_data-name2   = ls_kesinti-name2.
      ls_xml_data-tckn    = ls_kesinti-tckn.
      ls_xml_data-vkn     = ls_kesinti-vkn.
      ls_xml_data-matrah  = ls_kesinti-matrah.
      ls_xml_data-tevkt   = ls_kesinti-tevkt.
      ls_xml_data-odmtr   = ls_kesinti-odmtr.
      COLLECT ls_xml_data INTO lt_xml_data.
      CLEAR ls_xml_data.

    ENDLOOP.


*    CASE P_DONEMB.
*      WHEN '01'.
    lv_donem_txt = 'Aylık'.
*      WHEN '02'.
*        lv_donem_txt = TEXT-d02.
*    ENDCASE.

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
           dtelno
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

    SELECT SINGLE *
    FROM ztax_ddl_vh_hsv
   WHERE hsv = @ls_beyg-hsv
   INTO @DATA(ls_vh_hsv).
*    CLEAR LS_HSV_VAL.
*    READ TABLE LT_HSV_VAL INTO LS_HSV_VAL WITH KEY DOMVALUE_L = LS_BEYG-HSV.
*
*    CONCATENATE '<hsv sifat="'
*                LS_HSV_VAL-DDTEXT
*                '">'
*                INTO LV_HSV.

    CONCATENATE '<hsv sifat="'
               ls_vh_hsv-description
                '">'
                INTO lv_hsv.


    CONCATENATE '<soyadi>'
                'SOYAD'
                '</soyadi>'
                INTO lv_hsvsoyadi.

    CONCATENATE '<adi>'
                'AD'
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

    CONCATENATE '<?xml version="1.0" encoding="ISO-8859-9"?>'
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
                '</mukellef>'
                lv_hsv
                lv_hsvsoyadi
                lv_hsvadi
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
                lv_deposta
                lv_dalankodu
                lv_dtelno
                '</duzenleyen>'
                '</genel>'
                '<ozel>'
                INTO lv_xml_string
                SEPARATED BY space.

    CONCATENATE lv_xml_string
                '<kesintiler>'
                INTO lv_xml_string
                SEPARATED BY space.

    LOOP AT lt_xml_data INTO ls_xml_data.

      CONCATENATE lv_xml_string
                  '<kesinti>'
                  '<soyadi>'
                  ls_xml_data-name2
                  '</soyadi>'
                  '<adi>'
                  ls_xml_data-name1
                  '</adi>'
                  INTO lv_xml_string
                  SEPARATED BY space.


      CLEAR lv_char_amount1.
      CLEAR lv_char_amount2.
      lv_char_amount1 = ls_xml_data-matrah.
      lv_char_amount2 = ls_xml_data-tevkt.
      SHIFT lv_char_amount1 LEFT DELETING LEADING space.
      SHIFT lv_char_amount2 LEFT DELETING LEADING space.

      IF ls_xml_data-tckn NE space.
        CONCATENATE lv_xml_string
                    '<tcKimlikNo>'
                    ls_xml_data-tckn
                    '</tcKimlikNo>'
                    INTO lv_xml_string
                    SEPARATED BY space.

      ELSE.
        CONCATENATE lv_xml_string
                    '<vergiNo>'
                    ls_xml_data-vkn
                    '</vergiNo>'
                    INTO lv_xml_string
                    SEPARATED BY space.
      ENDIF.

      CONCATENATE lv_xml_string
                  '<vergiyeTabiMatrah>'
                  lv_char_amount1
                  '</vergiyeTabiMatrah>'
                  '<tutar>'
                  lv_char_amount2
                  '</tutar>'
                  '<odemeTuru>'
                  ls_xml_data-odmtr
                  '</odemeTuru>'
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
                '_kesinti'
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
                                                                    iv_content_type = 'application/xml'
                                                                    iv_filename     = 'beyanname.txt' ) ).
          lo_mail->send( IMPORTING et_status = DATA(lt_status) ).

*          COMMIT WORK.
        CATCH cx_bcs_mail INTO DATA(lo_err).
          DATA(lv_error) = lo_err->get_longtext( ) .
      ENDTRY.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_ztax_ddl_i_vat2_kes_report DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ztax_ddl_i_vat2_kes_report IMPLEMENTATION.

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
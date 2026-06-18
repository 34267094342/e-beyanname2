  METHOD get_payments.

    DATA ls_mg          TYPE mty_mg.
    DATA lt_mg          TYPE mtty_mg.
    DATA lt_lfb1        TYPE mtty_lfb1.
    DATA ls_lfb1        TYPE mty_lfb1.
    DATA ls_data        TYPE mty_data.
    DATA ls_data_k      TYPE mty_data.
    DATA lt_data        TYPE mtty_data.
    DATA ls_ode         TYPE mty_ode_smpl.
    DATA lt_lifnr       TYPE mtty_data.
    DATA ls_lifnr       TYPE mty_data.
    DATA lt_data_k      TYPE mtty_data.
    DATA lt_data_191    TYPE mtty_data_191.
    DATA lt_ode         TYPE TABLE OF mty_ode_smpl.
    DATA lt_mg_range    TYPE mtty_mg.
    DATA lt_data_wh     TYPE mtty_data.

    DATA lv_amount_k    TYPE p LENGTH 16 DECIMALS 2..
    DATA lv_amount_191  TYPE p LENGTH 16 DECIMALS 2.

    DATA lt_mmt TYPE TABLE OF ztax_t_mmt.
    DATA ls_mmt TYPE ztax_t_mmt.
    DATA lt_mmt_lifnr TYPE TABLE OF ztax_t_mmt.

    TYPES: BEGIN OF lty_lfa1,
             lifnr TYPE string,            " Business Partner Number
             name1 TYPE string,            " Name 1
             name2 TYPE string,            " Name 2
             org1  TYPE string,   " OrganizationBPName1  ← YENİ
             org2  TYPE string,   " OrganizationBPName2  ← YENİ
             stras TYPE string,            " Street
             regio TYPE string,            " Region
             mcod3 TYPE string,            " Additional Code
             land1 TYPE string,            " Country
             stcd2 TYPE string,            " Tax Number
           END OF lty_lfa1.


    DATA lt_lfa1 TYPE TABLE OF lty_lfa1.
    DATA ls_lfa1 TYPE lty_lfa1.
    DATA lr_hkont TYPE RANGE OF hkont.
    FIELD-SYMBOLS <fs_ode>       TYPE ztax_ddl_i_brf_payments.
    FIELD-SYMBOLS <fs_data>      TYPE mty_data.
    FIELD-SYMBOLS <fs_data_191>  TYPE mty_data_191.

*    CLEAR et_ode.
*    CLEAR ms_button_pushed.
*    CLEAR mv_mod.
*    ms_button_pushed-ode = abap_true.


    IF iv_bukrs IS NOT INITIAL.
      p_bukrs = iv_bukrs.
    ENDIF.

    IF iv_gjahr IS NOT INITIAL.
      p_gjahr = iv_gjahr.
    ENDIF.
    IF iv_monat IS NOT INITIAL.
      p_monat = iv_monat.
    ENDIF.
    IF iv_donemb IS NOT INITIAL.
      P_donemb = iv_donemb.
    ENDIF.

    me->fill_range( EXPORTING iv_low   = p_monat
                IMPORTING et_range = mr_monat ).


    get_item_data( IMPORTING et_mg       = lt_mg
                             et_data     = lt_data
                             et_data_191 = lt_data_191
                             et_lfb1     = lt_lfb1 ).

    SELECT Country AS land1,
           Region AS bland,
           RegionName AS bezei
           FROM I_RegionText
           WHERE Language EQ @sy-langu
           INTO TABLE @DATA(lt_t005u).
**
    SELECT country AS land1,
           countryname AS landx
           FROM i_countrytext "t005t
           WHERE language EQ @sy-langu
           INTO TABLE @DATA(lt_t005t).
*
*    SELECT mindk,
*           mtext
*           FROM t059t
*           WHERE spras EQ @sy-langu
*            INTO TABLE @DATA(lt_gricd_txt)
*             .
*
    SELECT mindk,
           beltr,
           acklm
           FROM ztax_t_modt
            INTO TABLE @DATA(lt_modt).
*
    SORT lt_t005u     BY land1 bland.
    SORT lt_t005t     BY land1.
*    SORT lt_gricd_txt BY mindk.
    SORT lt_modt      BY mindk.

    lt_lifnr = lt_data.
    DELETE lt_lifnr WHERE lifnr EQ space.

    SORT lt_lifnr BY bukrs gjahr belnr.
    SORT lt_data BY bukrs gjahr belnr docln.
    DELETE ADJACENT DUPLICATES FROM lt_data COMPARING bukrs gjahr belnr docln. "YiğitcanÖzdemir Sonradan eklendi
    lt_data_k = lt_data.

    CLEAR lt_mg_range[].
    MOVE-CORRESPONDING lt_mg[] TO lt_mg_range[].
    SORT lt_mg_range ASCENDING BY hkont.
    DELETE ADJACENT DUPLICATES FROM lt_mg_range COMPARING hkont.
    CLEAR lr_hkont[].
    lr_hkont = VALUE #( FOR ls_mg_range IN lt_mg_range
                          ( sign   = 'I'
                            option = 'EQ'
                            low    = ls_mg_range-hkont ) ).



*    DELETE lt_data   WHERE lifnr NE space.
*    DELETE lt_data   WHERE racct NOT IN lr_hkont.
*    OR racct NOT IN lr_hkont.
*    DELETE lt_data_k WHERE lifnr EQ space AND racct IN lr_hkont.

    SELECT itab~bukrs AS bukrs,
           itab~belnr AS belnr,
           itab~gjahr AS gjahr,
           wh~withholdingtaxtype AS witht,
           wh~withholdingtaxcode AS wt_withcd,
           wh~whldgtaxamtincocodecrcy AS taxamount,
           wh~whldgtaxbaseamtincocodecrcy AS baseamount
    FROM @lt_data AS itab INNER JOIN i_withholdingtaxitem AS wh
               ON wh~companycode EQ  itab~bukrs
               AND wh~accountingdocument EQ itab~belnr
               AND wh~fiscalyear EQ itab~gjahr
*               AND wh~accountingdocumentitem EQ itab~docln
     ORDER BY bukrs , belnr , gjahr , witht
     INTO CORRESPONDING FIELDS OF TABLE @lt_data_wh.
    DELETE ADJACENT DUPLICATES FROM lt_data_wh COMPARING bukrs belnr gjahr witht.

    SORT lt_data_191 BY rbukrs
                        gjahr
                        belnr.

    SORT lt_data_k BY bukrs
                      gjahr
                      belnr.

    SORT lt_data BY bukrs
                    gjahr
                    belnr.

    LOOP AT lt_data INTO ls_data.

      CLEAR ls_ode.
      CLEAR lv_amount_k.
      CLEAR lv_amount_191.

      CASE ls_data-witht.
        WHEN 'S1' OR 'S2' OR 'S3' OR 'S4'.
          ls_lfb1-mindk = '22'.
        WHEN 'S8'.
          CASE ls_data-wt_withcd.
            WHEN 'G9'.
              ls_lfb1-mindk = '22'.
            WHEN 'G8'.
              ls_lfb1-mindk = '156'.
          ENDCASE.
        WHEN 'T3' OR 'S7' OR 'T4'.
          ls_lfb1-mindk = '156'.
        WHEN 'S5' OR 'S6'.
          ls_lfb1-mindk = '41'.
        WHEN 'S9'.
          ls_lfb1-mindk = '279'.
        WHEN 'T5' OR 'ST'.
          ls_lfb1-mindk = '281'.
        WHEN 'T2'.
          ls_lfb1-mindk = '61'.
      ENDCASE.

      ls_ode-mindk   = ls_lfb1-mindk.

      CASE ls_data-lifnr.
        WHEN space.
          READ TABLE lt_lifnr INTO ls_lifnr WITH KEY bukrs = ls_data-bukrs
                                                     gjahr = ls_data-gjahr
                                                     belnr = ls_data-belnr
                                                     BINARY SEARCH.
          IF ls_lifnr-stcd2 IS NOT INITIAL.
            CASE strlen( ls_lifnr-stcd2 ).
              WHEN 11.
                ls_ode-tckn = ls_lifnr-stcd2.
              WHEN 10.
                ls_ode-vkn  = ls_lifnr-stcd2.
            ENDCASE.
          ELSE.
            CASE strlen( ls_lifnr-stcd2 ).
              WHEN 11.
                ls_ode-tckn = ls_lifnr-stcd2.
              WHEN 10.
                ls_ode-vkn  = ls_lifnr-stcd2.
            ENDCASE.
          ENDIF.
        WHEN OTHERS.
          IF ls_data-lifnr IS NOT INITIAL
         AND ( ls_data-name1 IS INITIAL AND ls_data-name_org1 IS INITIAL ) .
            LOOP AT lt_lifnr INTO ls_lifnr WHERE bukrs = ls_data-bukrs
                                             AND gjahr = ls_data-gjahr
                                             AND belnr = ls_data-belnr
                                             AND ( name1 IS NOT INITIAL OR name_org1 IS NOT INITIAL ).
*              MOVE-CORRESPONDING ls_lifnr TO ls_data.
              ls_data-lifnr = ls_lifnr-lifnr.
              " Önce FirstName/LastName'e bak
              " Boşsa OrganizationBPName1/2'ye bak
              IF ls_lfa1-name1 IS NOT INITIAL.
                ls_ode-name1 = ls_lfa1-name1.   " ← FirstName → soyadı kolonu
                ls_ode-name2 = ls_lfa1-name2.   " ← LastName  → adı kolonu
              ELSEIF ls_lfa1-org1 IS NOT INITIAL.
                ls_ode-name1 = ls_lfa1-org1.    " ← OrganizationBPName1 → soyadı
                ls_ode-name2 = ls_lfa1-org2.    " ← OrganizationBPName2 → adı
              ENDIF.
              ls_data-stras = ls_lifnr-stras.
*              ls_data-mcod3 = ls_lifnr-mcod3.
              ls_data-land1 = ls_lifnr-land1.
              ls_data-stcd2 = ls_lifnr-stcd2.
*              ls_data-stcd3 = ls_lifnr-stcd3.
              ls_data-regio = ls_lifnr-regio.
              EXIT.
            ENDLOOP.
          ENDIF.
          ls_lifnr-lifnr = ls_data-lifnr.

          IF ls_data-name1 IS NOT INITIAL.
            ls_lifnr-name1 = ls_data-name1.
            ls_lifnr-name2 = ls_data-name2.
          ELSEIF ls_data-name_org1 IS NOT INITIAL.
            ls_lifnr-name1 = ls_data-name_org1.
            ls_lifnr-name2 = ls_data-name_org2.
          ENDIF.
          ls_lifnr-stras = ls_data-stras.
*          ls_lifnr-mcod3 = ls_data-mcod3.
          ls_lifnr-land1 = ls_data-land1.
          ls_lifnr-stcd2 = ls_data-stcd2.
*          ls_lifnr-stcd3 = ls_data-stcd3.
*{   REPLACE        NP4K900309                                        7
*\          ls_lifnr-regio = ls_data-regio.
          ls_lifnr-regio = ls_data-regio.
          CASE strlen( ls_lifnr-stcd2 ).
            WHEN 11.
              ls_ode-tckn = ls_lifnr-stcd2.
            WHEN 10.
              ls_ode-vkn  = ls_lifnr-stcd2.
          ENDCASE.
          IF ls_lifnr-stcd2 IS INITIAL.
            CASE strlen( ls_lifnr-stcd2 ).
              WHEN 11.
                ls_ode-tckn = ls_lifnr-stcd2.
              WHEN 10.
                ls_ode-vkn  = ls_lifnr-stcd2.
            ENDCASE.
          ENDIF.
*}   REPLACE
      ENDCASE.


      READ TABLE lt_data_191 TRANSPORTING NO FIELDS WITH KEY rbukrs = ls_data-bukrs
                                                             gjahr  = ls_data-gjahr
                                                             belnr  = ls_data-belnr
                                                             BINARY SEARCH.
      CASE sy-subrc.
        WHEN 0.
          LOOP AT lt_data_191 ASSIGNING <fs_data_191> FROM sy-tabix.
            IF <fs_data_191>-rbukrs NE ls_data-bukrs OR
               <fs_data_191>-gjahr  NE ls_data-gjahr OR
               <fs_data_191>-belnr  NE ls_data-belnr.
              EXIT.
            ENDIF.
            ADD <fs_data_191>-hsl TO lv_amount_191.
            CLEAR <fs_data_191>-hsl.
          ENDLOOP.
      ENDCASE.

      READ TABLE lt_data_k TRANSPORTING NO FIELDS WITH KEY bukrs = ls_data-bukrs
                                                           gjahr = ls_data-gjahr
                                                           belnr = ls_data-belnr
                                                          BINARY SEARCH.
      CASE sy-subrc.
        WHEN 0.
          LOOP AT lt_data_k ASSIGNING <fs_data> FROM sy-tabix.
            IF <fs_data>-bukrs NE ls_data-bukrs OR
               <fs_data>-gjahr NE ls_data-gjahr OR
               <fs_data>-belnr NE ls_data-belnr.
              EXIT.
            ENDIF.
            ADD <fs_data>-hsl TO lv_amount_k.
            CLEAR <fs_data>-hsl.
          ENDLOOP.
      ENDCASE.

      READ TABLE lt_t005u INTO DATA(ls_t005u) WITH KEY land1 = ls_lifnr-land1
                                                       bland = ls_lifnr-regio
                                                       BINARY SEARCH.

      READ TABLE lt_t005t INTO DATA(ls_t005t) WITH KEY land1 = ls_lifnr-land1
                                                       BINARY SEARCH.


      READ TABLE lt_lfb1 INTO ls_lfb1 WITH KEY bukrs = ls_data-bukrs
                                               lifnr = ls_lifnr-lifnr
                                               BINARY SEARCH.

      "07.07.2025 - hesap kırılımından azınlık göstergesine ulaşma
      READ TABLE lt_mg INTO ls_mg WITH KEY bukrs = ls_data-bukrs
                                           hkont = ls_data-racct
                                           BINARY SEARCH.

      ls_ode-lifnr  = ls_lifnr-lifnr.
      " DÜZELTİLMİŞ (name1/2 önce, org fallback):
      IF ls_lifnr-name1 IS NOT INITIAL.
        ls_ode-name2 = ls_lifnr-name2.      " ← ad
        ls_ode-name1 = ls_lifnr-name1.      " ← soyad
      ELSEIF ls_lifnr-name_org1 IS NOT INITIAL.
        ls_ode-name2 = ls_lifnr-name_org1.  " ← fallback: org1 = ad
        ls_ode-name1 = ls_lifnr-name_org2.  " ← fallback: org2 = soyad
      ENDIF.


      CONCATENATE ls_lifnr-stras
*                  ls_lifnr-mcod3
                  ls_t005u-bezei
                  ls_t005t-landx
                  INTO ls_ode-adres
                  SEPARATED BY space.

*{   REPLACE        NP4K900309                                        1
*\      CASE strlen( ls_data-stcd2 ).
      "      CASE strlen( ls_data-stcd2 ).
*}   REPLACE
*{   REPLACE        NP4K900309                                        3
*\        WHEN 11.
      "        WHEN 11.
*}   REPLACE
*{   REPLACE        NP4K900309                                        2
*\          ls_ode-tckn = ls_data-stcd2.
      "  ls_ode-tckn = ls_data-stcd2.
*}   REPLACE
*{   REPLACE        NP4K900309                                        4
*\        WHEN 10.
      "        WHEN 10.
*}   REPLACE
*{   REPLACE        NP4K900309                                        5
*\          ls_ode-vkn  = ls_data-stcd2.
      "     ls_ode-vkn  = ls_data-stcd2.
*}   REPLACE
*{   REPLACE        NP4K900309                                        6
*\      ENDCASE.
      "   ENDCASE.
*}   REPLACE

      ls_ode-belnr   = ls_data-belnr.
      ls_ode-gjahr   = ls_data-gjahr.
*      IF ls_lfb1-mindk IS INITIAL.
*        ls_ode-mindk   = ls_mg-mindk.
*      ELSE.
*        ls_ode-mindk   = ls_lfb1-mindk.
*      ENDIF.

*      READ TABLE lt_gricd_txt INTO DATA(ls_gricd_txt) WITH KEY mindk = ls_ode-mindk
*                                                               BINARY SEARCH.

*      ls_ode-mtext   = ls_gricd_txt-mtext.
      ls_ode-budat   = ls_data-budat.
      ls_ode-xblnr   = ls_data-xblnr.
*      ls_ode-gyst    = ls_data_k-hsl +
*                       lv_amount_k -
*                       lv_amount_191.

      READ TABLE lt_modt INTO DATA(ls_modt) WITH KEY mindk = ls_ode-mindk
                                                     BINARY SEARCH.

*      ls_ode-gyst    = lv_amount_k.
*      ls_ode-kst     = ls_data-hsl.
      READ TABLE lt_data_wh INTO DATA(ls_data_wh) WITH KEY bukrs = ls_data-bukrs
                                                           belnr = ls_data-belnr
                                                           gjahr = ls_data-gjahr
                                                           witht = ls_data-witht BINARY SEARCH.
      ls_ode-gyst = ls_data_wh-baseamount. "Çağatay-Sümeyye
      ls_ode-kst = ls_data_wh-taxamount.

      ls_ode-beltr   = ls_modt-beltr.
      ls_ode-beltrx  = ls_modt-acklm.

      COLLECT ls_ode INTO lt_ode.

      CLEAR ls_t005u.
      CLEAR ls_t005t.
      CLEAR ls_lifnr.
      CLEAR ls_lfb1.
*      CLEAR ls_gricd_txt.
      CLEAR ls_modt.
      CLEAR ls_mg.
      CLEAR ls_data_wh.

      DELETE lt_data_wh WHERE bukrs = ls_data-bukrs
                    AND belnr = ls_data-belnr
                    AND gjahr = ls_data-gjahr
                    AND witht = ls_data-witht.


    ENDLOOP.

    CLEAR lt_lfb1.
    CLEAR ls_lfb1.

    SELECT *

        FROM ZTAX_T_mmt
        WHERE bukrs EQ @p_bukrs
          AND gjahr EQ @p_gjahr
          AND monat EQ @P_monat
          INTO TABLE @lt_mmt.

    lt_mmt_lifnr = lt_mmt.
    DELETE lt_mmt_lifnr WHERE lifnr+0(1) EQ 'L'.

    IF lines( lt_mmt_lifnr ) GT 0.
      SELECT supplier AS lifnr,
             but000~FirstName              AS name1,  " ← gerçek isim
             but000~LastName               AS name2,  " ← gerçek soyad
             but000~OrganizationBPName1    AS org1,   " ← org adı  ← YENİ
             but000~OrganizationBPName2    AS org2,   " ← org soyad ← YENİ
             StreetName AS stras,
             Region AS regio,
*             mcod3
             Country AS land1,
             TaxNumber2 AS stcd2,
             TaxNumber3 AS stcd3

             FROM i_supplier AS lfa1
             INNER JOIN I_BusinessPartner AS but000 ON but000~BusinessPartner EQ lfa1~Supplier
             FOR ALL ENTRIES IN @lt_mmt_lifnr
             WHERE Supplier EQ @lt_mmt_lifnr-lifnr
               INTO TABLE @lt_lfa1.

      SELECT supplier AS lifnr,
             companycode AS bukrs
*             gricd
             FROM i_suppliercompany
             FOR ALL ENTRIES IN @lt_mmt_lifnr
             WHERE supplier EQ @lt_mmt_lifnr-lifnr
             INTO TABLE @lt_lfb1.

    ENDIF.

    SORT lt_lfa1 BY lifnr.
    SORT lt_lfb1 BY bukrs lifnr.

    LOOP AT lt_mmt INTO ls_mmt.
      CLEAR ls_modt.
*      CLEAR ls_gricd_txt.
      CLEAR ls_lfb1.
      CLEAR ls_t005t.
      CLEAR ls_t005u.
      CLEAR ls_lfa1.
      CLEAR ls_ode.

      ls_ode-belnr = '**********'.
      ls_ode-gjahr = ls_mmt-gjahr.
      ls_ode-gyst  = ls_mmt-gyst.
      ls_ode-kst   = ls_mmt-kst.
      ls_ode-lifnr = ls_mmt-lifnr.

      CASE ls_mmt-lifnr+0(1).
        WHEN 'L'.
          ls_ode-adres = ls_mmt-adres.
          ls_ode-mindk = ls_mmt-mindk.
          ls_ode-name1 = ls_mmt-name1.
          ls_ode-name2 = ls_mmt-name2.
          ls_ode-tckn  = ls_mmt-tckn.
          ls_ode-vkn   = ls_mmt-vkn.
          ls_ode-sosg  = abap_true.
        WHEN OTHERS.

          READ TABLE lt_lfa1 INTO ls_lfa1 WITH KEY lifnr = ls_mmt-lifnr BINARY SEARCH.

          READ TABLE lt_t005u INTO ls_t005u WITH KEY land1 = ls_lfa1-land1
                                                     bland = ls_lfa1-regio
                                                     BINARY SEARCH.

          READ TABLE lt_t005t INTO ls_t005t WITH KEY land1 = ls_lfa1-land1
                                                     BINARY SEARCH.


          READ TABLE lt_lfb1 INTO ls_lfb1 WITH KEY bukrs = p_bukrs
                                                   lifnr = ls_ode-lifnr
                                                   BINARY SEARCH.


          CONCATENATE ls_lfa1-stras
                      ls_lfa1-mcod3
                      ls_t005u-bezei
                      ls_t005t-landx
                      INTO ls_ode-adres
                      SEPARATED BY space.

          CASE strlen( ls_lfa1-stcd2 ).
            WHEN 11.
              ls_ode-tckn = ls_lfa1-stcd2.
            WHEN 10.
              ls_ode-vkn  = ls_lfa1-stcd2.
          ENDCASE.
          IF ls_lfa1-stcd2 IS INITIAL.
*            CASE strlen( ls_lfa1-stcd3 ).
*              WHEN 11.
*                ls_ode-tckn = ls_lfa1-stcd3.
*              WHEN 10.
*                ls_ode-vkn  = ls_lfa1-stcd3.
*            ENDCASE.
          ENDIF.

          ls_ode-mindk  = ls_lfb1-mindk.
          ls_ode-name1  = ls_lfa1-name1.
          ls_ode-name2  = ls_lfa1-name2.


      ENDCASE.


*      READ TABLE lt_gricd_txt INTO ls_gricd_txt WITH KEY mindk = ls_ode-mindk
*                                                         BINARY SEARCH.


      READ TABLE lt_modt INTO ls_modt WITH KEY mindk = ls_ode-mindk
                                               BINARY SEARCH.

*      ls_ode-mtext    = ls_gricd_txt-mtext.
      ls_ode-beltr   = ls_modt-beltr.
      ls_ode-beltrx  = ls_modt-acklm.
*      ls_ode-row_color = mc_new_line_color.

      COLLECT ls_ode INTO lt_ode.
      CLEAR ls_ode.



    ENDLOOP.

    MOVE-CORRESPONDING lt_ode[] TO mt_ode[].
    MOVE-CORRESPONDING lt_ode[] TO et_ode[].

    LOOP AT et_ode ASSIGNING <fs_ode>.
*      <fs_ode>-cell_tab = define_edit_fields( iv_mod = 'O'
*                                              iv_str = '' ).
      <fs_ode>-gyst = abs( <fs_ode>-gyst ).
      <fs_ode>-kst  = abs( <fs_ode>-kst ).
    ENDLOOP.


  ENDMETHOD.
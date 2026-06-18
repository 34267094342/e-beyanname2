  PROTECTED SECTION.

    METHODS:
      get_documents IMPORTING iv_bukrs   TYPE bukrs OPTIONAL
                              iv_gjahr   TYPE gjahr OPTIONAL
                              iv_monat   TYPE monat OPTIONAL
                              iv_donemb  TYPE ztax_e_donemb OPTIONAL
                              iv_beyant  TYPE ztax_e_beyant OPTIONAL
                    EXPORTING et_collect TYPE mtty_collect,
      get_item_data EXPORTING et_mg       TYPE mtty_mg
                              et_data     TYPE mtty_data
                              et_data_191 TYPE mtty_data_191
                              et_lfb1     TYPE mtty_lfb1,
      fill_period IMPORTING ir_monat       TYPE ANY TABLE
                  EXPORTING er_fiscyearper TYPE ANY TABLE,
      fill_range IMPORTING iv_sign   TYPE c DEFAULT 'I'
                           iv_option TYPE ztax_e_option DEFAULT 'EQ'
                           iv_low    TYPE clike DEFAULT space
                           iv_high   TYPE clike DEFAULT space
                 EXPORTING et_range  TYPE STANDARD TABLE
                 .
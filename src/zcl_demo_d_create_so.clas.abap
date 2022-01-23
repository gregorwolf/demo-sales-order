CLASS zcl_demo_d_create_so DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_demo_d_create_so IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.
    DATA: lt_data TYPE ztdemo_i_salesorder_tx.

    io_read->retrieve(
        EXPORTING
            iv_node = is_ctx-node_key
            it_key  = it_key
        IMPORTING
            eo_message    = eo_message
            et_data       = lt_data
            et_failed_key = et_failed_key
    ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
      IF <ls_data>-salesorder IS INITIAL.
        SELECT MAX( salesorder ) AS salesorderid
            FROM ztab_so
            INTO <ls_data>-salesorder.


        ADD 1 TO <ls_data>-salesorder.
        <ls_data>-salesorder = |{ <ls_data>-salesorder ALPHA = IN }|.

      ENDIF.
    ENDLOOP.
    "...Need to create Reference DATA otherwise io_modify->update throws error
    GET REFERENCE OF <ls_data> INTO DATA(lr_data).

    io_modify->update(
    EXPORTING
        iv_node = is_ctx-node_key
        iv_key  = lr_data->key
        is_data = lr_data
    ).
  ENDMETHOD.
ENDCLASS.

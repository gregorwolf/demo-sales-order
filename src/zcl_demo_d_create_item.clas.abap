CLASS zcl_demo_d_create_item DEFINITION
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



CLASS zcl_demo_d_create_item IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA: lt_root_data TYPE ztdemo_i_salesorder_tx,
          lt_data      TYPE ztdemo_i_salesorderitem_tx,
          ls_return    TYPE bapiret2.

    io_read->retrieve_by_association(
      EXPORTING
            iv_node        = zif_demo_i_salesorder_tx_c=>sc_node-zdemo_i_salesorderitem_tx
            it_key         = it_key
            iv_association = zif_demo_i_salesorder_tx_c=>sc_association-zdemo_i_salesorderitem_tx-to_root
            iv_fill_data   = abap_true
      IMPORTING
            eo_message    = eo_message
            et_data       = lt_root_data
            et_failed_key = et_failed_key
    ).

    READ TABLE lt_root_data INDEX 1 ASSIGNING FIELD-SYMBOL(<fs_root>).

    IF <fs_root> IS ASSIGNED.
      " Find the highest used item number in both active and draft data (draft table)
      SELECT SINGLE
          FROM ztab_soi
          FIELDS MAX( salesorderitem ) AS salesorderitem
          WHERE salesorder = @<fs_root>-salesorder
      into @DATA(lv_max_salesorderitem).

      " If there are no entries, set a start value
      IF lv_max_salesorderitem IS INITIAL.
        lv_max_salesorderitem = '0000000000'.
      ENDIF.

      io_read->retrieve(
          EXPORTING
              iv_node = is_ctx-node_key
              it_key  = it_key
          IMPORTING
              eo_message    = eo_message
              et_data       = lt_data
              et_failed_key = et_failed_key
      ).

      " Assign numbers to each newly created item and trigger the modification in BOPF
      LOOP AT lt_data REFERENCE INTO DATA(lr_data).
        IF lr_data->salesorderitem IS INITIAL.
          ADD 10 TO lv_max_salesorderitem.
          lr_data->salesorder = <fs_root>-salesorder.
          lr_data->salesorderitem = |{ lv_max_salesorderitem ALPHA = IN }|.

          io_modify->update(
            EXPORTING
              iv_node           = is_ctx-node_key    " uuid of node
              iv_key            = lr_data->key   " key of line
              is_data           = lr_data            " ref to modified data
              it_changed_fields = VALUE #(
                ( zif_demo_i_salesorder_tx_c=>sc_node_attribute-zdemo_i_salesorderitem_tx-salesorder )
                ( zif_demo_i_salesorder_tx_c=>sc_node_attribute-zdemo_i_salesorderitem_tx-salesorderitem )
               )
          ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

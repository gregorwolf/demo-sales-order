CLASS zcl_demo_d_check_or_determine DEFINITION
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



CLASS zcl_demo_d_check_or_determine IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.
    " The sales order data is typed with BO node's combined table type
    DATA lt_so_data TYPE ztdemo_i_salesorder_tx.
    DATA lv_action_enabled TYPE abap_bool.

    " (1) Retrieve the data of the invoice's node instance
    io_read->retrieve(
      EXPORTING
        iv_node  = is_ctx-node_key
        it_key   = it_key
      IMPORTING
        et_data = lt_so_data ).

    " (2) Create a property helper object
    DATA(lo_property_helper) = NEW /bobf/cl_lib_h_set_property( io_modify  = io_modify
                                                            is_context = is_ctx ).

    " (3) Action not enabled when invoice is set to PAID
    LOOP AT lt_so_data ASSIGNING FIELD-SYMBOL(<s_so>).

      IF <s_so>-overallstatus = 'P'.
        lv_action_enabled = abap_false.
      ELSE.
        lv_action_enabled = abap_true.
      ENDIF.

      lo_property_helper->set_action_enabled(
            iv_action_key = zif_demo_i_salesorder_tx_c=>sc_action-zdemo_i_salesorder_tx-set_to_paid
            iv_key        = <s_so>-key
            iv_value      = lv_action_enabled ).

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

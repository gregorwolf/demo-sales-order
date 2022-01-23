class ZCL_DEMO_A_SET_TO_PAID definition
  public
  inheriting from /BOBF/CL_LIB_A_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_ACTION~EXECUTE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEMO_A_SET_TO_PAID IMPLEMENTATION.


  method /BOBF/IF_FRW_ACTION~EXECUTE.
    " Typed with node's combined table type
    DATA(lt_sales_order) = VALUE ztdemo_i_salesorder_tx( ).

    " READING BO data ----------------------------------------------

    " Retrieve the data of the requested node instance
    io_read->retrieve(
      EXPORTING
        iv_node         = is_ctx-node_key
        it_key          = it_key
      IMPORTING
        et_data         = lt_sales_order
    ).

    " WRITING BO data ---------------------------------------------

    LOOP AT lt_sales_order ASSIGNING FIELD-SYMBOL(<s_sales_order>).

    " Set the attribue billing_status to new value
    <s_sales_order>-billingstatus = 'P'.  " PAID

    " Set the attribue overall_status to new value
    IF
        <s_sales_order>-overallstatus = 'N' OR <s_sales_order>-overallstatus = ' '.
        <s_sales_order>-overallstatus  = 'P'.  " PAID
    ENDIF.

    " Update the changed data (billig_status) of the node instance
    io_modify->update(
      EXPORTING
        iv_node               = is_ctx-node_key
        iv_key                = <s_sales_order>-key
        iv_root_key           = <s_sales_order>-root_key
        is_data               = REF #( <s_sales_order>-node_data )
        it_changed_fields     = VALUE #(
          ( zif_demo_i_salesorder_tx_c=>sc_node_attribute-zdemo_i_salesorder_tx-billingstatus )
          ( zif_demo_i_salesorder_tx_c=>sc_node_attribute-zdemo_i_salesorder_tx-overallstatus )
        )
      ).
    ENDLOOP.


  endmethod.
ENDCLASS.

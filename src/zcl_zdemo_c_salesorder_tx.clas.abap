class ZCL_ZDEMO_C_SALESORDER_TX definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZDEMO_C_SALESORDER_TX IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( `CDS~ZDEMO_C_SALESORDER_TX` )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20220831152728.
  endmethod.
ENDCLASS.

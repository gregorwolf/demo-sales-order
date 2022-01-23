@AbapCatalog.sqlViewName: 'ZDEMO_I_SOI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item'

@ObjectModel: { 
    modelCategory: #BUSINESS_OBJECT,
    writeActivePersistence: 'ZTAB_SOI',

    semanticKey:  [ 'SalesOrder', 'SalesOrderItem' ],   
    
    createEnabled: true,
    deleteEnabled: true,
    updateEnabled: true
}

define view ZDEMO_I_SalesOrderItem_TX as select from ztab_soi as SalesOrderItem 
/* Compositional associations    */
association [1..1] to ZDEMO_I_SalesOrder_TX as _SalesOrder on $projection.SalesOrder = _SalesOrder.SalesOrder
/* Cross BO associations         */
association [0..1] to SEPM_I_Product_E          as _Product    on $projection.Product = _Product.Product
{
    @ObjectModel.readOnly: true
    key salesorder as SalesOrder,
    @ObjectModel.readOnly: true
    key salesorderitem as SalesOrderItem,
    @ObjectModel.foreignKey.association: '_Product'
    @ObjectModel.mandatory: true
    @UI.textArrangement: #TEXT_LAST
    product as Product,
    quantity as Quantity,
    /*  Exposed associations  */
    @ObjectModel.association.type: [#TO_COMPOSITION_PARENT, #TO_COMPOSITION_ROOT]
    _SalesOrder,

    _Product
}

@AbapCatalog.sqlViewName: 'ZDEMO_C_SOI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sales Order Item - Consumption View'

@Search.searchable: true 

@ObjectModel: { 
   semanticKey:['SalesOrder', 'SalesOrderItem'],
   transactionalProcessingDelegated: true,
    createEnabled: true,
    deleteEnabled: true,
    updateEnabled: true
}

@Metadata.layer: #CUSTOMER
    
@UI: {
    headerInfo: {
        typeName: 'Sales Order Item',
        typeNamePlural: 'Sales Order Items',
        title: { type: #STANDARD, value: 'SalesOrderItem' }
    }
}

@UI.Facet: [
  {
    label: 'Details',
    targetQualifier: 'Details',
    type: #FIELDGROUP_REFERENCE,
    purpose: #STANDARD
  }
]


define view ZDEMO_C_SalesOrderItem_TX as select from ZDEMO_I_SalesOrderItem_TX
 /* Composition and cross BO associations  */
 association [1..1] to ZDEMO_C_SalesOrder_TX as _SalesOrder on $projection.SalesOrder = _SalesOrder.SalesOrder
 {
    @ObjectModel.readOnly: true
    @Search.defaultSearchElement: true
    @UI: {
      lineItem: [ { position: 5, label: 'Sales Order', importance: #HIGH } ],
      identification:[ { position: 5, label: 'Sales Order' } ]
    }
    @UI.fieldGroup: [
      {
        type: #STANDARD,
        position: 5,
        qualifier: 'Details',
        groupLabel: 'Details'
      }
    ]
    key SalesOrder,
    @ObjectModel.readOnly: true
    @UI: {
      lineItem: [ { position: 10, label: 'Position', importance: #HIGH } ],
      identification:[ { position: 10, label: 'Position' } ]
    }
    @UI.fieldGroup: [
      {
        type: #STANDARD,
        position: 10,
        qualifier: 'Details'
      }
    ]
    key SalesOrderItem,
    @UI: {
      lineItem: [ { position: 20, label: 'Product', importance: #MEDIUM } ],
      identification:[ { position: 20, label: 'Product' } ]
    }
    @UI.fieldGroup: [
      {
        type: #STANDARD,
        position: 20,
        qualifier: 'Details'
      }
    ]
    Product,
    @UI: {
      lineItem: [ { position: 30, importance: #MEDIUM, label: 'Quantity' } ],
      identification:[ { position: 30, label: 'Quantity' } ]
    }
    @UI.fieldGroup: [
      {
        type: #STANDARD,
        position: 30,
        qualifier: 'Details'
      }
    ]
    Quantity,
    /* Associations */
    _Product,
    @ObjectModel.association.type:  [ #TO_COMPOSITION_ROOT, #TO_COMPOSITION_PARENT ]
    _SalesOrder
}

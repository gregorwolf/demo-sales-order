@AbapCatalog.sqlViewName: 'ZDEMO_C_SO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order for transactional app'
                
@OData.publish: true

@VDM.viewType: #CONSUMPTION
                
@ObjectModel.semanticKey: 'SalesOrder'
@ObjectModel.transactionalProcessingDelegated: true
              
@ObjectModel.createEnabled: true
@ObjectModel.deleteEnabled: true
@ObjectModel.updateEnabled: true

@UI.headerInfo: { 
    typeName: 'Sales Order', 
    typeNamePlural: 'Sales Orders', 
    title: {
      value: 'SalesOrder',
      type: #STANDARD
    }
}

// Not exposed in 7.50
@UI.Facet: [
  {
    label: 'BusinessPartner',
    targetQualifier: 'BusinessPartner',
    type: #FIELDGROUP_REFERENCE,
    purpose: #STANDARD
  },
  {
    label: 'OrderValue',
    targetQualifier: 'OrderValue',
    type: #FIELDGROUP_REFERENCE,
    purpose: #STANDARD
  }
]
             
  define view ZDEMO_C_SalesOrder_TX
        as select from ZDEMO_I_SalesOrder_TX as Document
        association [0..*] to ZDEMO_C_SalesOrderItem_TX as _Item on _Item.SalesOrder = Document.SalesOrder
  {
                
        @UI.lineItem.position: 10
        @UI.lineItem: 
        [
         { type: #FOR_ACTION, position: 1, dataAction: 'BOPF:SET_TO_PAID', label: 'Set to Paid' }
        ]        
        @UI.identification.position: 10
        key Document.SalesOrder,
                
        @UI.lineItem.position: 20
        @UI.identification.position: 20
        @UI.fieldGroup: [
          {
            type: #STANDARD,
            position: 1 ,
            qualifier: 'BusinessPartner',
            groupLabel: 'Business Partner'
          }
        ]
        @UI.selectionField.position: 10
        Document.BusinessPartner,
                
        Document.CurrencyCode,
                
        @UI.lineItem.position: 50  
        @UI.identification.position: 50
        @UI.fieldGroup: [
          {
            type: #STANDARD,
            position: 1 ,
            qualifier: 'OrderValue',
            groupLabel: 'Order Value'
          }
        ]
        Document.GrossAmount,
                
        @UI.lineItem.position: 60
        @UI.identification.position: 60
        @UI.fieldGroup: [
          {
            type: #STANDARD,
            position: 2 ,
            qualifier: 'OrderValue'
          }
        ]
        Document.NetAmount,
                
        @UI.lineItem.position: 30
        @UI.selectionField.position: 30
        @UI.identification.position: 30
        Document.BillingStatus,
                
        @UI.lineItem.position: 40
        @UI.selectionField.position: 40
        @UI.identification.position: 40
        Document.OverallStatus,
                      
        /* Exposing value via associations */ 
        @UI.lineItem:  { value: '.CompanyName', position: 15 }
        Document._BusinessPartner,
                
        Document._Currency,   
        Document._BillingStatus, 
        Document._OverallStatus,
        /* Exposing value via associations */ 
        @ObjectModel.association.type:  [ #TO_COMPOSITION_CHILD ]
        _Item   
                
  }                        
                            

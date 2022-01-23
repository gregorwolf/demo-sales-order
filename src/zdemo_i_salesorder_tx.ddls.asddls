@AbapCatalog.sqlViewName: 'ZDEMO_I_SO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order for transactional app'
                
@ObjectModel.semanticKey: 'SalesOrder'
                
@ObjectModel.modelCategory: #BUSINESS_OBJECT 
@ObjectModel.compositionRoot: true  
@ObjectModel.transactionalProcessingEnabled: true  
@ObjectModel.writeActivePersistence: 'ZTAB_SO'
                
@ObjectModel.createEnabled: true
@ObjectModel.deleteEnabled: true 
@ObjectModel.updateEnabled: true
                
                
define view ZDEMO_I_SalesOrder_TX 
                
    as select from ztab_so as SalesOrder  -- the sales order table is the data source for this view
/* Compositional associations */
        
association [0..*] to ZDEMO_I_SalesOrderItem_TX   as _Item on $projection.SalesOrder = _Item.SalesOrder                
                
    association [0..1] to SEPM_I_BusinessPartner            as _BusinessPartner on $projection.BusinessPartner = _BusinessPartner.BusinessPartner
                
    association [0..1] to SEPM_I_Currency                   as _Currency        on $projection.CurrencyCode     = _Currency.Currency
                
    association [0..1] to SEPM_I_SlsOrdBillingStatusText    as _BillingStatus   on $projection.BillingStatus    = _BillingStatus.SalesOrderBillingStatus
                
    association [0..1] to Sepm_I_SalesOrdOverallStatus      as _OverallStatus   on $projection.OverallStatus    = _OverallStatus.SalesOrderOverallStatus    
                
{        
    key SalesOrder.salesorder           as SalesOrder, 
                
    //@ObjectModel.foreignKey.association: '_BusinessPartner'
    SalesOrder.businesspartner          as BusinessPartner,       
                
    @ObjectModel.foreignKey.association: '_Currency'  
    @Semantics.currencyCode: true
    SalesOrder.currencycode             as CurrencyCode, 
                
    @Semantics.amount.currencyCode: 'CurrencyCode'   
    SalesOrder.grossamount              as GrossAmount, 
                
    @Semantics.amount.currencyCode: 'CurrencyCode'
    SalesOrder.netamount                as NetAmount, 
                
    @ObjectModel.foreignKey.association: '_BillingStatus'
    SalesOrder.billingstatus            as BillingStatus, 
                
    @ObjectModel.foreignKey.association: '_OverallStatus'
    SalesOrder.overallstatus            as OverallStatus,
    /* Exposed associations */ 
    @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
    _Item,                 
                
    /* Associations */ 
    _BusinessPartner,
    _Currency,
    _BillingStatus, 
    _OverallStatus     
}

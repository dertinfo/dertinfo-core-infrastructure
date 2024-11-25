/*
Outline: IaC for the Api Management Instance.
Author: David Hall
Created: 2024-11-21
Prerequisites:
- The application insights instance for monitoring must exist 
*/

// #####################################################
// Parameters
// #####################################################

@description('The initials of the owner.')
param ownerInitials string = 'di'

@description('The name of the workload being deployed.')
param workloadName string = 'integration'

@description('The app insights instance name.')
param applicationInsightsName string

@description('The app insights instance resource group name.')
param applicationInsightsResourceGroupName string

@description('Environment tag for resources.')
@allowed([
  'dev'
  'stg'
  'prod'
])
param environmentTag string = 'dev'

@description('The email of the APIM publisher.')
param publisherEmail string

@description('The name of the APIM publisher.')
param publisherName string

// #####################################################
// Variables
// #####################################################

// Build the names for the resources
var uniqueStr = substring(uniqueString(resourceGroup().id),0,4)
var apimInstanceName = '${ownerInitials}-${uniqueStr}-apim-${workloadName}-${environmentTag}'

// #####################################################
// References
// #####################################################

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
  scope: resourceGroup(applicationInsightsResourceGroupName)
}

// #####################################################
// Resources
// #####################################################

// #####################################################
// Modules
// #####################################################

// #####################################################
// Azure Verified Modules (AVM)
// #####################################################

module apiManagementService 'br/public:avm/res/api-management/service:0.6.0' = {
  name: 'serviceDeployment'
  params: {
    // Required parameters
    name: apimInstanceName
    publisherEmail: publisherEmail
    publisherName: publisherName
    // Non-required parameters
    location: resourceGroup().location
    sku: 'Consumption'
    loggers: [
      {
        credentials: {
          instrumentationKey: applicationInsights.properties.InstrumentationKey
        }
        description: 'Logger to Azure Application Insights'
        isBuffered: false
        loggerType: 'applicationInsights'
        name: 'logger'
        resourceId: applicationInsights.id
      }
    ]
    managedIdentities:{
      systemAssigned: true
    }
    policies: [
      {
        format: 'xml'
        value: loadTextContent('./apim-policy.xml')
      }
    ]
  }
}

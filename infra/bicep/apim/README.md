# Bicep for deployment of APIM

This IaC deploys both the APIM resource with a managed identity and the associated policies for the APIM. 

Individual APIs are attached to the APIM instance via the IaC defined against their workloads (typically /infra/bicep/apim)

## Deployment using the Azure CLI

### Template
```
az login --tenant [TenantId]
az account set --subscription [SubscriptionId]
az group create --name [ResourceGroupName] --location [Location]
az deployment group create --resource-group [ResourceGroupName] --template-file main.bicep --parameters @main-[env].json
```
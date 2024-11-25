# Bicep for deployment of APIM

This IaC deploys both the APIM resource with a managed identity and the associated policies for the APIM. 

Individual APIs are attached to the APIM instance via the IaC defined against their workloads (typically /infra/bicep/apim)

## Deployment using the Azure CLI

### Template
```
az login --tenant [TenantId]
az account set --subscription [SubscriptionId]
az group create --name di-rg-apim-core-[env] --location uksouth
az deployment group create --resource-group di-rg-apim-core-[env] --template-file main.bicep --parameters @main-[env].json
```

### For Staging
```
cd infra/bicep/apim
az group create --name di-rg-apim-integration-stg --location uksouth
az deployment group create --resource-group di-rg-apim-integration-stg --template-file main.bicep --parameters main-stg.json
```
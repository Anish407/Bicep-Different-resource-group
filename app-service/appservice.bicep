param appServicePlanName string
param location string
param appServiceName string
param userAssginedResourceId string
param userAssginedClientId string
param keyvaultUri string
@secure()
param secret string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssginedResourceId}': {}
    }
  }

  properties: {
    serverFarmId: appServicePlan.id
    clientAffinityEnabled: false
    siteConfig: {
      alwaysOn: true
      ftpsState: 'Disabled'
    }
  }
}

resource appSettings 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: appService
  properties: {
    'keyvaultUri': keyvaultUri
    'msiId': userAssginedClientId
    'secret': secret
  }

  dependsOn: [
    appServicePlan
  ]
}

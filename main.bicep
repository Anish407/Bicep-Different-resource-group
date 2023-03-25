param appServicePlanName string
param appServiceName string
param location string= resourceGroup().location
param kvName  string
param secretName string
param rgName  string

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing  = {
  name: kvName
  scope: resourceGroup('subscriptionId',rgName)
}

module msi 'msi/msi.bicep' = {
  name: 'msiDeploy'
  params: {
    msiName: 'anishmsi'
    rgName: rgName
  }
}

module appService 'app-service/appservice.bicep' = {
  name: 'myAppservice'
  params: {
    secret: kv.getSecret(secretName)
    location:location
    appServiceName: appServiceName
    appServicePlanName: appServicePlanName
    keyvaultUri: kv.properties.vaultUri
    userAssginedClientId: msi.outputs.msiclientId
    userAssginedResourceId: msi.outputs.msiId
  }
}

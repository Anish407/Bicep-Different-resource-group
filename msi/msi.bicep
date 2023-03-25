param msiName string
param rgName  string


resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing  ={
  name: msiName
  scope: resourceGroup('subscriptionId',rgName)
}

output msiclientId string = msi.properties.clientId
output msiId string= msi.id




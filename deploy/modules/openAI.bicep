param location string
param openaiName string
param openaiSubDomain string = openaiName
param modelName string
param modelCapacity int = 20

resource openai 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: openaiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: openaiSubDomain
  }
  
  resource gpt35turbo16k 'deployments@2023-05-01' = {
    name: modelName
    sku: {
      name: 'Standard'
      capacity: modelCapacity
    }
    properties: {
      model: {
        format: 'OpenAI'
        name: modelName
      }
      versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    }
  }
}

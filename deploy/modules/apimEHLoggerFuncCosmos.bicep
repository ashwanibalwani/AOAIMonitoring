param location string

resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: uniqueName
  resource eventHubLogger 'loggers@2023-03-01-preview' = {
    name: 'eventHub'
    properties: {
      loggerType: 'azureEventHub'
      credentials: {
        connectionString: eventHubNamespace::eventHub::senderAuth.listKeys().primaryConnectionString
        name: eventHubNamespace::eventHub.name
      }
    }
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2023-01-01-preview' = {
  name: uniqueName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
  properties: {
    isAutoInflateEnabled: false
  }
  resource eventHub 'eventhubs@2023-01-01-preview' = {
    name: 'apimEvents'
    properties: {
      messageRetentionInDays: 7
      partitionCount: 1
    }
    resource senderAuth 'authorizationRules@2023-01-01-preview' = {
      name: 'apimSend'
      properties: {
        rights: [
          'Send'
        ]
      }
    }
  }
}

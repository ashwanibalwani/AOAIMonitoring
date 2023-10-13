@description('The location for all resources to be deployed')
param location string = 'AustraliaEast'

@description('The prefix to be used for all resource names, should only be alphanumeric')
param prefix string = 'demo'

@description('The Azure OpenAI model to be deployed')
param azureOpenAIModelName string = 'gpt-35-turbo-16k'

@description('Capacity to be set for the specified Azure OpenAI model deployment')
param azureOpenAIModelCapacity int = 20

param apimEmail string = 'noreply@microsoft.com'

var uniqueNameFormat = '${prefix}-{0}-${uniqueString(resourceGroup().id, prefix)}'
var uniqueShortName = '${prefix}${uniqueString(resourceGroup().id, prefix)}'
var deploymentPrefix = uniqueString(deployment().name, location, prefix, resourceGroup().id)

// TODO: Option for BYO API-M
module apim 'modules/apim.bicep' = {
  name: '${deploymentPrefix}-apim'
  params: {
    location: location
    apimName: format(uniqueNameFormat, 'apim')
    apimEmail: apimEmail
    appInsightsName: format(uniqueNameFormat, 'appins')
    logAnalyticsName: format(uniqueNameFormat, 'logs')
  }
}

module loggerToCosmos 'modules/apimEHLoggerFuncCosmos.bicep' = {
  name: '${deploymentPrefix}-logger'
  params: {
    location: location
    
  }
}

module apimPolicy 'modules/apimOpenAIPolicyFragment.bicep' = {
  name: '${deploymentPrefix}-policy'
  params: {
    location: location
  }
}

// TODO: Option for BYO OpenAI
module openAI 'modules/openAI.bicep' = {
  name: '${deploymentPrefix}-openai'
  params: {
    location: location
    openaiName: format(uniqueNameFormat, 'openai')
    openaiSubDomain: uniqueShortName
    modelName: azureOpenAIModelName
    modelCapacity: azureOpenAIModelCapacity
  }
}

// TODO: Option for no/BYO API
module openAIAPI 'modules/openAIAPI.bicep' = {
  name: '${deploymentPrefix}-oaiapi'
  params: {
    location: location
  }
}

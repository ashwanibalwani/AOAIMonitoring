@description('The location for all resources to be deployed')
param location string = 'AustraliaEast'

@description('The prefix to be used for all resource names, should only be alphanumeric')
param prefix string = 'demo'

param apimEmail string = 'noreply@microsoft.com'

var uniqueName = '${toLower(prefix)}${uniqueString(prefix, resourceGroup().id)}'

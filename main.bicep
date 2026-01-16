// =============================================================================
// Azure AI Foundry Project + AI Search with Private Endpoints
// =============================================================================
// このテンプレートは以下のリソースを作成します：
// - 仮想ネットワーク（プライベートエンドポイント用サブネット含む）
// - Azure AI Foundry Project (Sweden Central)
// - Azure AI Search (Japan East)
// - 各サービスのプライベートエンドポイント
// - プライベートDNSゾーン
// =============================================================================

targetScope = 'resourceGroup'

// -----------------------------------------------------------------------------
// パラメータ
// -----------------------------------------------------------------------------
@description('リソース名のプレフィックス')
param prefix string = 'aifoundry'

@description('環境名 (dev, stg, prod)')
@allowed(['dev', 'stg', 'prod'])
param environment string = 'dev'

@description('VNetのリージョン')
param vnetLocation string = 'japaneast'

@description('AI Foundry Projectのリージョン')
param aiFoundryLocation string = 'swedencentral'

@description('AI Searchのリージョン')
param aiSearchLocation string = 'japaneast'

@description('AI SearchのSKU')
@allowed(['basic', 'standard', 'standard2', 'standard3'])
param aiSearchSku string = 'basic'

// -----------------------------------------------------------------------------
// 変数
// -----------------------------------------------------------------------------
var resourceSuffix = '${prefix}-${environment}'
var vnetName = 'vnet-${resourceSuffix}'
var aiProjectName = 'aiproject-${resourceSuffix}'
var aiSearchName = 'search-${resourceSuffix}'

// -----------------------------------------------------------------------------
// 仮想ネットワーク
// -----------------------------------------------------------------------------
module vnet 'modules/network/vnet.bicep' = {
  name: 'deploy-vnet'
  params: {
    vnetName: vnetName
    location: vnetLocation
  }
}

// -----------------------------------------------------------------------------
// Azure AI Foundry Project
// -----------------------------------------------------------------------------
module aiFoundryProject 'modules/ai-foundry/project.bicep' = {
  name: 'deploy-ai-foundry-project'
  params: {
    projectName: aiProjectName
    location: aiFoundryLocation
  }
}

// -----------------------------------------------------------------------------
// Azure AI Search
// -----------------------------------------------------------------------------
module aiSearch 'modules/ai-search/search.bicep' = {
  name: 'deploy-ai-search'
  params: {
    searchServiceName: aiSearchName
    location: aiSearchLocation
    sku: aiSearchSku
  }
}

// -----------------------------------------------------------------------------
// プライベートエンドポイント - AI Foundry Project
// -----------------------------------------------------------------------------
module peAiFoundry 'modules/private-endpoint/private-endpoint.bicep' = {
  name: 'deploy-pe-ai-foundry'
  params: {
    privateEndpointName: 'pe-${aiProjectName}'
    location: vnetLocation
    subnetId: vnet.outputs.privateEndpointSubnetId
    privateLinkServiceId: aiFoundryProject.outputs.projectId
    groupIds: ['account']
    privateDnsZoneName: 'privatelink.services.ai.azure.com'
    vnetId: vnet.outputs.vnetId
  }
}

// -----------------------------------------------------------------------------
// プライベートエンドポイント - AI Search
// -----------------------------------------------------------------------------
module peAiSearch 'modules/private-endpoint/private-endpoint.bicep' = {
  name: 'deploy-pe-ai-search'
  params: {
    privateEndpointName: 'pe-${aiSearchName}'
    location: vnetLocation
    subnetId: vnet.outputs.privateEndpointSubnetId
    privateLinkServiceId: aiSearch.outputs.searchServiceId
    groupIds: ['searchService']
    privateDnsZoneName: 'privatelink.search.windows.net'
    vnetId: vnet.outputs.vnetId
  }
}

// -----------------------------------------------------------------------------
// 出力
// -----------------------------------------------------------------------------
output vnetId string = vnet.outputs.vnetId
output aiFoundryProjectId string = aiFoundryProject.outputs.projectId
output aiSearchId string = aiSearch.outputs.searchServiceId

// =============================================================================
// Azure AI Searchモジュール
// =============================================================================

@description('AI Search サービス名')
param searchServiceName string

@description('リージョン')
param location string

@description('SKU')
@allowed(['basic', 'standard', 'standard2', 'standard3'])
param sku string = 'basic'

@description('レプリカ数')
@minValue(1)
@maxValue(12)
param replicaCount int = 1

@description('パーティション数')
@allowed([1, 2, 3, 4, 6, 12])
param partitionCount int = 1

// -----------------------------------------------------------------------------
// Azure AI Search
// -----------------------------------------------------------------------------
resource searchService 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: searchServiceName
  location: location
  sku: {
    name: sku
  }
  properties: {
    replicaCount: replicaCount
    partitionCount: partitionCount
    hostingMode: 'default'
    publicNetworkAccess: 'disabled'
    networkRuleSet: {
      ipRules: []
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// -----------------------------------------------------------------------------
// 出力
// -----------------------------------------------------------------------------
output searchServiceId string = searchService.id
output searchServiceName string = searchService.name

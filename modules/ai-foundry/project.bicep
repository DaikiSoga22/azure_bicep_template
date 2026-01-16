// =============================================================================
// Azure AI Foundry Projectモジュール
// =============================================================================

@description('プロジェクト名')
param projectName string

@description('リージョン')
param location string

@description('プロジェクトの表示名')
param displayName string = ''

// -----------------------------------------------------------------------------
// Azure AI Foundry Project (AIServices Account)
// -----------------------------------------------------------------------------
resource aiProject 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: projectName
  location: location
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: projectName
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// -----------------------------------------------------------------------------
// 出力
// -----------------------------------------------------------------------------
output projectId string = aiProject.id
output projectName string = aiProject.name
output projectEndpoint string = aiProject.properties.endpoint

// =============================================================================
// プライベートエンドポイントモジュール
// =============================================================================

@description('プライベートエンドポイント名')
param privateEndpointName string

@description('リージョン')
param location string

@description('サブネットID')
param subnetId string

@description('接続先サービスのリソースID')
param privateLinkServiceId string

@description('グループID（サービスタイプ）')
param groupIds array

@description('プライベートDNSゾーン名')
param privateDnsZoneName string

@description('VNet ID')
param vnetId string

// -----------------------------------------------------------------------------
// プライベートDNSゾーン
// -----------------------------------------------------------------------------
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

// -----------------------------------------------------------------------------
// プライベートDNSゾーンとVNetのリンク
// -----------------------------------------------------------------------------
resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateEndpointName}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}

// -----------------------------------------------------------------------------
// プライベートエンドポイント
// -----------------------------------------------------------------------------
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${privateEndpointName}-connection'
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: groupIds
        }
      }
    ]
  }
}

// -----------------------------------------------------------------------------
// プライベートDNSゾーングループ
// -----------------------------------------------------------------------------
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: replace(privateDnsZoneName, '.', '-')
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

// -----------------------------------------------------------------------------
// 出力
// -----------------------------------------------------------------------------
output privateEndpointId string = privateEndpoint.id
output privateDnsZoneId string = privateDnsZone.id

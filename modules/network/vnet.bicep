// =============================================================================
// 仮想ネットワークモジュール
// =============================================================================

@description('VNet名')
param vnetName string

@description('リージョン')
param location string

@description('VNetのアドレス空間')
param addressPrefix string = '10.0.0.0/16'

@description('プライベートエンドポイント用サブネットのアドレス範囲')
param privateEndpointSubnetPrefix string = '10.0.1.0/24'

// -----------------------------------------------------------------------------
// 仮想ネットワーク
// -----------------------------------------------------------------------------
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-private-endpoints'
        properties: {
          addressPrefix: privateEndpointSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

// -----------------------------------------------------------------------------
// 出力
// -----------------------------------------------------------------------------
output vnetId string = vnet.id
output vnetName string = vnet.name
output privateEndpointSubnetId string = vnet.properties.subnets[0].id

using 'main.bicep'

// =============================================================================
// デプロイパラメータ
// =============================================================================

// リソース名のプレフィックス（小文字英数字のみ）
param prefix = 'aifoundry'

// 環境名
param environment = 'dev'

// VNetのリージョン
param vnetLocation = 'japaneast'

// AI Foundry Projectのリージョン
param aiFoundryLocation = 'swedencentral'

// AI Searchのリージョン
param aiSearchLocation = 'japaneast'

// AI SearchのSKU
param aiSearchSku = 'basic'

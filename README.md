# Azure AI Foundry + AI Search Bicep テンプレート

Azure AI Foundry Project と Azure AI Search をプライベートエンドポイント付きでデプロイするための Bicep テンプレートです。

## アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                     リソースグループ                          │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐  │
│  │              仮想ネットワーク (Japan East)             │  │
│  │  ┌────────────────────────────────────────────────┐  │  │
│  │  │     プライベートエンドポイント用サブネット          │  │  │
│  │  │  ┌─────────────┐    ┌─────────────┐          │  │  │
│  │  │  │ PE: AI      │    │ PE: AI      │          │  │  │
│  │  │  │ Foundry     │    │ Search      │          │  │  │
│  │  │  └──────┬──────┘    └──────┬──────┘          │  │  │
│  │  └─────────┼──────────────────┼──────────────────┘  │  │
│  └────────────┼──────────────────┼──────────────────────┘  │
│               │                  │                         │
│               ▼                  ▼                         │
│  ┌─────────────────────┐  ┌─────────────────────┐         │
│  │ AI Foundry Project  │  │ Azure AI Search     │         │
│  │ (Sweden Central)    │  │ (Japan East)        │         │
│  └─────────────────────┘  └─────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## 前提条件

- Azure CLI がインストールされていること
- Bicep CLI がインストールされていること（Azure CLI に含まれています）
- Azure サブスクリプションへのアクセス権があること

## ファイル構成

```
.
├── main.bicep              # メインテンプレート
├── main.bicepparam         # パラメータファイル
├── README.md
└── modules/
    ├── network/
    │   └── vnet.bicep      # 仮想ネットワーク
    ├── ai-foundry/
    │   └── project.bicep   # AI Foundry Project
    ├── ai-search/
    │   └── search.bicep    # AI Search
    └── private-endpoint/
        └── private-endpoint.bicep  # プライベートエンドポイント
```

## デプロイ手順

### 1. Azure にログイン

```powershell
az login
```

### 2. リソースグループを作成

```powershell
az group create --name rg-aifoundry-dev --location japaneast
```

### 3. デプロイを実行

```powershell
az deployment group create `
  --resource-group rg-aifoundry-dev `
  --template-file main.bicep `
  --parameters main.bicepparam
```

### 4. （オプション）What-if で事前確認

```powershell
az deployment group what-if `
  --resource-group rg-aifoundry-dev `
  --template-file main.bicep `
  --parameters main.bicepparam
```

## パラメータ

| パラメータ | 説明 | デフォルト値 |
|-----------|------|-------------|
| `prefix` | リソース名のプレフィックス | `aifoundry` |
| `environment` | 環境名 (dev/stg/prod) | `dev` |
| `vnetLocation` | VNet のリージョン | `japaneast` |
| `aiFoundryLocation` | AI Foundry のリージョン | `swedencentral` |
| `aiSearchLocation` | AI Search のリージョン | `japaneast` |
| `aiSearchSku` | AI Search の SKU | `basic` |

## 注意事項

- すべてのサービスはプライベートエンドポイント経由でのみアクセス可能です
- パブリックアクセスは無効化されています
- プライベートDNSゾーンが自動的に作成・リンクされます

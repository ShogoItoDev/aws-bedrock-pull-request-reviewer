# 免責事項

  - 掲載内容は作成者が独自に考案・開発したものであり、所属組織等を代表するものではありません。
  - 掲載内容は検証目的であり、利用による損害等の発生には対応致しかねます。
  - 参考にした文献・Webサイトは脚注に記載しています（2024/5閲覧）

# 概要

  - プルリクエストをAWS Bedrockの基盤モデル(Claude3 Sonnet)により自動レビューするソリューション
　
# アーキテクチャ

# 前提条件

 - AWS Bedrockの[モデルアクセス]より、[Anthropic]-[Claude 3 Sonnet]を有効化しておく

## セットアップ

1.system_identifier を任意の値に変更する。

  ```
  variable "system_identifier" {
  type    = string
  default = "demo"
  }
  ```
  
2.terraformを実行する。

 ```
 terraform init
 terraform apply
 ```


## 使用方法

1. CodeCommitで任意のブランチを作成後、プルリクエストを実施する。

2. 基盤モデル(Claude3 Sonnet)によりコメントが投稿されます。

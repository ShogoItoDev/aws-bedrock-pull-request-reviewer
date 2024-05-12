![Github Created At](https://img.shields.io/github/created-at/ShogoItoDev/aws-bedrock-pull-request-reviewer)

# 免責事項

  - 掲載内容は作成者が独自に考案・開発したものであり、所属組織等を代表するものではありません。
  - 掲載内容は検証目的であり、利用による損害等の発生には対応致しかねます。

# 概要

  - プルリクエストをAWS Bedrockの基盤モデル(Claude3 Sonnet)により自動レビューするソリューション
　
# アーキテクチャ
![diagram](https://github.com/ShogoItoDev/aws-bedrock-pull-request-reviewer/assets/30908643/72277d12-5eb9-4069-8985-8e12cc33ba90)


# 前提条件

 - AWS Bedrockの[モデルアクセス]より、[Anthropic]-[Claude 3 Sonnet]を有効化しておく

![Screenshot_03](https://github.com/ShogoItoDev/aws-bedrock-pull-request-reviewer/assets/30908643/953f0ff2-0dc8-46cb-ae0a-2f66bd494fbe)


# セットアップ

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


# 使用方法

1. CodeCommitで任意のブランチを作成後、プルリクエストを実施する。
   
![Screenshot_01](https://github.com/ShogoItoDev/aws-bedrock-pull-request-reviewer/assets/30908643/2a6227f5-2306-448c-89ab-213ae5c203cc)

2. 基盤モデル(Claude3 Sonnet)によりコメントが投稿される。
   
![Screenshot_02](https://github.com/ShogoItoDev/aws-bedrock-pull-request-reviewer/assets/30908643/91025221-6593-4c34-bb18-3b4e4be7a67e)


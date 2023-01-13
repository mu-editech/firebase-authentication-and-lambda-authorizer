# 概要
本リポジトリは、Zennで公開中の[Firebase AuthenticationとLambda Authorizerで認証ありのAPI開発をする方法](https://zenn.dev/mutech/books/856a3101d080a1)のソースを公開したものです。

# 構成図
![lambda_authorizer](https://user-images.githubusercontent.com/58851029/212321359-e1c5dfd2-dfb1-4f1a-a74d-61d3d73a7c9c.png)


# デプロイ方法方法
## 事前準備
※詳細な手順は、Zennの記事をご覧ください。


1. Firebase Authenticationでダミーのユーザーを作成し、秘密鍵を取得しておく。
2. パラメータストアに `google-credentials-json` の名前でリソースを作成し、1の秘密鍵JSONをコピペしておく。


## デプロイ
```.sh
# Makefileが存在する同階層ディレクトリにて以下を打つ
$ make deploy
```

# 動作確認方法

```.sh
# 1.認証付きAPIを認証なしで叩く。認証がないためはじかれる。
$ curl https://hogehoge/hello_world
{"messege": "Unauthorization"}

# 2.Firebase Authentication にトークンを取得しにいく([API_KEY],[YOUR_MAIL_ADDRESS],[PASSWORD]は任意の値に変更)
$ curl 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]' \
-H 'Content-Type: application/json' \
--data-binary '{"email":"[YOUR_MAIL_ADDRESS]","password":"[PASSWORD]","returnSecureToken":true}'
{
  "kind": "identitytoolkit#VerifyPasswordResponse",
  "localId": "localId",
  "email": "bob@example.com",
  "displayName": "BobDylan",
  "idToken": "piyopiyotoken",
  "registered": true,
  "refreshToken": "mogemoge",
  "expiresIn": "3600"
}


# 3.ヘッダーにトークンを埋め込んで叩くと、認証が通る!
$ curl https://hogehoge/hello_world -H 'authorization: piyopiyotoken'
{"result": "Hello World!"}
```

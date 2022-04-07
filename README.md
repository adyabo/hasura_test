## What

Qiita 記事のサンプルコード (バックエンド側)
[Next.js, Hasura, Cloud Run, Cloud SQLでWebアプリを作る！0 から デプロイまで！](https://qiita.com/tokio_k_/items/56479ff846ee36fd58eb)



## リポジトリ

* クライアント(Next.js)側 リポジトリ
  * https://github.com/tokio-k/memo-app-sample
* バックエンド(Hasura)側 リポジトリ (このリポジトリ)
  * https://github.com/tokio-k/memo-app-sample-hasura

## 使用技術

* TypeScript
* Next.js
* Auth0
* Apollo
* GraphQL Code Generator
* Hasura
* Cloud Run
* Cloud Build
* Cloud SQL

## Auth0 rules

```hasura-jwt-claims.js
function (user, context, callback) {
  const namespace = "https://hasura.io/jwt/claims";
  context.accessToken[namespace] =
    {
      'x-hasura-default-role': 'user',
      'x-hasura-allowed-roles': ['user'],
      'x-hasura-user-id': user.user_id
    };
  callback(null, user, context);
}

```

```select-and-insert-user.js
function (user, context, callback) {
  const axios = require('axios');

  const uid = user.user_id;
  const name = user.name;

  const url = `${configuration.HASURA_URL}/v1/graphql`;
  const header = {
    'content-type' : 'application/json',
    'x-hasura-admin-secret': configuration.HASURA_GRAPHQL_ADMIN_SECRET
  };

  const graphqlQuery = {
    query: `mutation ($name: String!, $uid: String!) {
  insert_user_one(object: {name: $name, uid: $uid}, on_conflict: {constraint: user_uid_key, update_columns: uid}) {
    id
  }
}`,
    variables: {name: name, uid: uid}
  };

  axios.post(url,{...graphqlQuery},{headers: header})
    .then(res => {
      const userId = res.data.data.insert_user_one.id;
      context.idToken[configuration.NAMESPACE+'/userId'] = userId;
      return callback(null, user, context);
  }).catch(err => {
      return callback(new Error(`Hasuraへのリクエストでエラーが発生しました。`));
  });
}

```

## 環境変数

#### Vercel

* NEXT_PUBLIC_HASURA_GRAPHQL_ENDPOINT
* NEXT_PUBLIC_AUTH0_CLIENT_ID
* NEXT_PUBLIC_AUTH0_DOMAIN
* NEXT_PUBLIC_APP_URL
#### Auth0 rules

* HASURA_GRAPHQL_ADMIN_SECRET
* HASURA_URL
* NAMESPACE

#### Cloud Build

* _DB_DATABASE
* _DB_HOST
* _DB_PASSWORD
* _DB_PORT
* _DB_USER
* _HASURA_ADMIN_SECRET
* _HASURA_JWT_SECRET


※ 自分で追加したもののみ記載(_TRIGGER_IDなどは未記載)
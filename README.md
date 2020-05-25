# MyBridgeSample

A sample application using GitHub API

## Environment

* Xcode 11.4.1
* Swift 5.2.2
* iOS >= 13.0

## Setup

`$ carthage bootstrap --platform iOS`

### 認証トークンを利用する場合

プロジェクト直下に `.github_api_token` ファイルを作成し、トークン（personal access token）を記載。

```
% cat .github_api_token
1234xxxxxxxxxx7890
```

作成しない場合はデフォルトのRate Limitの制限となる  
[Rate Limit参照](#rate-limit)

## Documentation

* [Library](Documentation/Library.md)
* [Enhancement](Documentation/Enhancement.md)

## GitHub API

### 使用API

* [search-users](https://developer.github.com/v3/search/#search-users)

### Rate Limit

* [Rate limiting](https://developer.github.com/v3/#rate-limiting)
* [the Search API has custom rate limit rules.](https://developer.github.com/v3/search/#rate-limit)

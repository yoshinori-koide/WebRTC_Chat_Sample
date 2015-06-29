## WebRTC Chat アプリケーションのエントリーポイント

本アプリはFluxの"パターン"を使用して実装されています。
ChatStoreのモデルクラスが起点となり、データ変更イベントによる通知、ビューの描画という一貫したフローでアプリケーションを記述します。

チャットの着信については通常のUIからの入力だけではない非同期な通信ですが、受信メッセージはChatStoreへの書き込みのみの1系統、
送信メッセージはChatStoreとChatCommでの配信の2系統の処理と分けています。

### 依存モジュールの読み込み

	React = require 'react'

### アプリケーションモジュールの読み込みと宣言

	ChatApp = require './components/ChatApp'

### アプリケーションのレンダリング開始

idが`chatApp`のエレメントの内部に`ChatApp`を埋め込みます。
```coffeescript

	React.render <ChatApp />, document.getElementById 'chatApp'

```

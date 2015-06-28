# WebRTC Chat Sample

WebRTC でのチャットアプリのサンプルです。

クライアント間の通信はWebRTCで行い、データの保存はlocalstorageで行います。

現状、WebRTCがスマホで動くのはAndroid版Chromeのみなので、対象ブラウザもAndroid版Chromeのみとします。

## 大まかな画面遷移

	ユーザー情報入力（未登録時）
		↓
	チャット画面

## ユーザー情報のデータ項目

* 表示名 … チャット窓に表示される名前
* 識別キー … ユーザーを識別するキー。WebRTCでは接続ごとに振られるIDは毎回異なるので、"ユーザー"を識別するためには別途キーが必要。

## チャットの画面構成

基本のターゲットはスマホサイズとする。

上段はチャット窓、中央に地図、最下部に入力窓を配置する。

## モジュールの構成

以下はアプリケーションのモジュール構成です。
ファイルはすべて、coffee-literate形式(.litcoffee)とします。

	src/
		app … アプリケーションのエントリーポイント
		action/
			ChatAction … アクションメソッドとイベントのバインド
		components/
			MainSection … 画面要素エレメントのトップ
			UserData … ユーザー情報入力画面
			ChatWindow … チャット画面
			MessageDisplay … 発言されたメッセージの描画画面
			MessageItem … チャットメッセージ描画項目
			MessageInput … メッセージの入力画面
		constants/
			ChatConstants … イベントラベルの列挙
		dispatcher/
			AppDispatcher … イベントディスパッチャの宣言
		store/
			ChatStore … データ保存とイベント発火ポイント
		webrtc/
			Chat … WebRTCによる接続と待ち受け

## ローカルでのビルド
適当なフォルダに本リポジトリのファイル丸ごとダウンロードし、

	$ npm install --dev

で実行に必要なフレームワーク(react,fluxなど)とビルドに必要なフレームワーク(grunt,webpackなど)を取得してきます。

	$ grunt

でsrc以下の.litcoffeeをビルドし、js/main.jsを生成します。んで、そのまま*.litcoffeeのwatchを続けます。
菅氏が不必要な場合はCTRL+Cで抜けてください。

## ローカルでの実行について

適当にWebサーバーを動かしてください。

今回は静的なコンテンツですので、Mac OS Xでしたら Fenix (http://fenixwebserver.com) が楽チンです。

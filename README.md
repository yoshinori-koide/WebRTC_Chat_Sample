# WebRTC Chat Sample

WebRTC でのチャットアプリのサンプルです。

クライアント間の通信はWebRTCで行い、データの保存はlocalstorageで行います。

現状、WebRTCがスマホで動くのはAndroid版Chromeのみ、PCではChrome及びFirefoxです。IEとSafariでは動きません。

上記の対象ブラウザで http://2015-camppro.github.io/WebRTC_Chat_Sample/ を開いてください。


## 大まかな画面遷移

	ユーザー情報入力（未登録時）
		↓
	チャット画面

## ユーザー情報のデータ項目

* 表示名 … チャット窓などUI上に表示される名前
* 識別キー … ユーザーを識別するキー。WebRTCでは接続ごとに振られるIDは毎回異なるので、"ユーザー"を識別するためには別途キーが必要。

## モジュールの構成

以下はアプリケーションのモジュール構成です。
ファイルはすべて、coffee-literate形式(.litcoffee)とします。

	src/
		app … アプリケーションのエントリーポイント
		actions/
			ChatActions … アクションメソッドとイベントのバインド
		components/
			ChatApp ... チャットアプリの全体構成
			ChatInput ... テキストの入力欄
			ChatItem ... 1件のメッセージを表示
			EditProf ... プロフィールの入力画面
			MainSection ... チャットメッセージ表示＋入力欄のメイン画面
			UserItem ... ユーザーの1件表示
			UsersSection ... ユーザーリスト表示
		constants/
			ChatConstants … イベントラベルの列挙
		dispatcher/
			AppDispatcher … イベントディスパッチャの宣言
		store/
			ChatStore … データ保存とイベント発火ポイント
		webrtc/
			ChatComm … WebRTCによる接続とチャットデータの送受信

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

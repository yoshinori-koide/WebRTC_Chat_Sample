# WebRTC Chat アプリケーションのエントリーポイント

## 依存モジュールの読み込み

	React = require 'react'

## アプリケーションの宣言

	ChatApp = require './components/ChatApp'

## アプリケーションのレンダリング開始

	React.render <ChatApp />, document.getElementById 'chatApp'

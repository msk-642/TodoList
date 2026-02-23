# TodoList App (iOS Portfolio)

SwiftUIとMVVMアーキテクチャを採用した、モダンな設計のTodo管理アプリです。
”保守性・テスト容易性・堅牢性”を意識したプロフェッショナルなコードベースを構築しています。

## 🚀 主な機能
- **Todo管理**: 追加、編集、削除、完了フラグのトグル。
- **詳細メモ機能**: 各項目に詳細なテキストを保存可能。
- **タイムスタンプ機能**: 作成日時および最終更新日時を自動記録し、一覧画面で確認可能。
- **ローカル永続化**: `UserDefaults` を利用したデータの保存。
- **モダンなUI/UX**: SwiftUIによる直感的な操作感、適切なフィードバック（アラート等）。

## 🛠 技術スタック / アーキテクチャ
### アーキテクチャ: MVVM
- **View**: SwiftUIを採用。状態（State/Binding）に基づいた宣言的なUI実装。
- **ViewModel**: アプリの動作ルールや計算処理をまとめ、表示画面(View)から独立。`ObservableObject` によるデータ連携。
- **Model**: シンプルなデータ構造。

### 特徴的な設計手法
- **プロトコル志向設計**
  - データの保存先や通信の仕組みを”入れ替え可能”な設計にしています。
- **依存注入 (DI)**
  - 必要な機能を外部から渡す設計にすることで、部品ごとの独立性を高めています。
- **ユニットテスト (XCTest)**
  - アプリの重要な計算ルールが正しく動くかを、プログラムによって自動検証しています。
  - 特に「データの作成日・更新日」が正しく記録されるかなど、手動では漏れやすい箇所の品質を保証しています。

## 🌟 こだわりポイント（技術的アピール）
- **安全な画面切り替え**: 
  - 画面を切り替える際に、どのデータが選択されたかを正確に判別して表示する、バグの起きにくい安全な仕組みを実装しました。
- **使いやすさの向上**:
  - 項目のどこを触っても反応するようにタップ範囲を広げるなど、細かな操作感にこだわっています。
- **品質への意識**:
  - 「新機能を入れたら別の場所が動かなくなった」というデグレ（退化）を防ぐため、自動テストの仕組みを構築しています。

## 📸 スクリーンショット / デモ
- **メイン画面（初回起動）**
<img width="250" alt="simulator_screenshot_71D3C98D-C6FD-4E4A-B83E-FD7930A9DC58" src="https://github.com/user-attachments/assets/4f3c4517-070f-4847-8133-72d5fef064b4" />


- **Todo追加画面**
<img width="250" alt="simulator_screenshot_63839CC0-E89E-4789-968B-EC1B450F07A5" src="https://github.com/user-attachments/assets/c0f66424-eb91-4745-a009-a543809e74a8" />


- **メイン画面からTodo追加画面へ遷移 ➡️ Todo追加**
<img src="https://github.com/user-attachments/assets/91231861-9749-4b44-ab8d-ddf689cc9e6b" width="250">


- **Todo詳細画面（Todo新規作成後）**
<img width="250" alt="simulator_screenshot_2222CBC4-062E-47DA-A3FD-1E12E54F750E" src="https://github.com/user-attachments/assets/10ecff6a-1f0a-4afb-a78d-c317761e5a82" />

 
- **Todoの詳細入力後保存 ➡️ メイン画面でTodoの更新時間が更新されていることを確認**
<img src="https://github.com/user-attachments/assets/018f37b4-0176-4dc6-a512-fe5a50a40dd9" width="250">


- **Todo削除後アプリ終了 ➡️ アプリ再起動してTodoの状態が保存されていることを確認**
<img src="https://github.com/user-attachments/assets/027a6572-3279-4596-a1e5-40ae8d96f2a3" width="250">


- **ユニットテスト実行結果OK**
<img width="250" src="https://github.com/user-attachments/assets/dffaaaf4-2dbf-493b-bd69-e8b0daf664c8" />


## 📂 プロジェクト構造

```text
TodoList/
├── AddTodoView.swift                # Todo追加画面
├── ContentView.swift                # メイン画面
├── Todo.swift                       # Todoモデル
├── TodoAPI.swift                    # API取得ロジック
├── TodoListApp.swift                # main
├── TodoListViewModel.swift          # データ操作ロジック
├── TodoRepository.swift             # データへのアクセス方法
├── TodoTextView.swift               # Todo詳細画面
├── UserDefaultsTodoStorage.swift    # ローカル保存リポジトリ
└── TodoListTests/
    └── TodoListViewModelTests.swift # ロジックテストコード
```

---
*Created by Masato Kobayashi (GitHub id:msk-642)*

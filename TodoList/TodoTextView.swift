//
//  AddTodoView.swift
//  TodoList
//
//  Created by MSK on 2026/01/29.
//

import SwiftUI

struct TodoTextView: View {
    // プロパティ
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TodoListViewModel
    
    @State private var todoIndex: Int
    @State private var title: String
    @State private var text: String
    @State private var showAlert: Bool = false
    
    // 初期化処理
    init (viewModel: TodoListViewModel, index: Int) {
        self.viewModel = viewModel
        self.todoIndex = index
        
        // 配列の範囲内かチェックして安全にアクセスする
        if viewModel.todos.indices.contains(index) {
            self.title = viewModel.todos[index].title
            self.text = viewModel.todos[index].text
        } else {
            // 範囲外時の初期化処理
            self.title = ""
            self.text = ""
        }
    }

    var body: some View {
        NavigationStack {
            ZStack (alignment: .topLeading) {
                TextEditor(text: $text)
                    .toolbar {
                        // ツールバー左上戻るボタン
                        ToolbarItem(placement: .cancellationAction) {
                            Button("戻る") {
                                dismiss()
                            }
                        }
                        // ツールバー右上保存ボタン
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("保存") {
                                // 保存処理
                                viewModel.addTodoText(text, at: todoIndex)
                                
                                // 完了表示
                                showAlert = true
                            }
                        }
                    }
                    // タイトル（親ビューからタイトルを受け取って設定する）
                    .navigationTitle($title)
                    .padding(.horizontal, 10)
                    // 完了インフォメーション
                    .alert("保存完了", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("内容を保存しました。")
                    }
                // Todo詳細テキストが空だったらプレースホルダーを表示
                if text.isEmpty {
                    Text("ここに詳細を入力")
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 10)
                        .allowsHitTesting(false)
                }
            }
        }
        .colorMultiply(Color(red: 240/255, green: 230/255, blue: 200/255))
    }
}

#Preview {
    // プレビュー用ダミーデータRepository
    final class PreviewTodoRepository: TodoRepositoryProtocol {
        var todos: [Todo] = [
            Todo(id: UUID(), title: "テスト", isCompleted: false)
        ]
        func load() -> [Todo] { todos }
        func refresh() async throws -> [Todo] { todos }
        func save(_ todos: [Todo]) { self.todos = todos }
    }
    
    let viewModel = TodoListViewModel(repository: PreviewTodoRepository())
    return TodoTextView(viewModel: viewModel, index: 0)
}

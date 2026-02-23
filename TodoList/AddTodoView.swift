//
//  AddTodoView.swift
//  TodoList
//
//  Created by MSK on 2026/01/29.
//

import SwiftUI

struct AddTodoView: View {

    // プロパティ
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TodoListViewModel

    @State private var title: String = ""

    var body: some View {
        NavigationStack {
            // Todo入力テキストフィールド
            Form {
                TextField("Todoを入力", text: $title)
            }
            // タイトル
            .navigationTitle("Todo追加")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    // キャンセルボタン押下時、メイン画面に戻る
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    // 追加ボタン押下時、Todo追加
                    Button("追加") {
                        viewModel.addTodo(title: title)
                        dismiss()
                    }
                    // Todo入力テキストフィールドが空だったら追加ボタンを無効化
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddTodoView(viewModel: TodoListViewModel())
}

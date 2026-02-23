//
//  ContentView.swift
//  TodoList
//
//  Created by MSK on 2026/01/29.
//

import SwiftUI

struct ContentView: View {

    // プロパティ
    @StateObject private var viewModel = TodoListViewModel()
    @State private var isShowingAddTodo = false
    // 選択されたTodoのインデックスを保持（nilなら非表示）
    @State private var selectedTodoIndex: Int?

    var body: some View {
        NavigationStack {
            // Todoテーブル
            List {
                // Todoを表示
                ForEach(viewModel.todos.indices, id: \.self) { index in
                    HStack {
                        // タイトルと余白部分全体をタップ領域にするためのグループ化
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.todos[index].title)
                                    .font(.body)
                                Text("作成: \(viewModel.todos[index].createdAt.formatted(date: .numeric, time: .shortened))  更新: \(viewModel.todos[index].updatedAt.formatted(date: .numeric, time: .shortened))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        // 余白部分もタップ可能にするため、形状を矩形として認識させる
                        .contentShape(Rectangle())
                        // Todo詳細画面に遷移
                        .onTapGesture {
                            selectedTodoIndex = index
                        }
                        
                        // 丸型チェックボックス
                        Image(systemName: viewModel.todos[index].isCompleted ? "checkmark.circle.fill" : "circle")
                            // チェックボックスをタップしてチェックマークをトグル
                            .onTapGesture {
                                viewModel.toggleCompleted(at: index)
                            }
                    }
                }
                // Todoを削除
                .onDelete(perform: viewModel.deleteTodo)
            }
            // タイトル
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Todo追加ボタン（＋）
                    Button {
                        isShowingAddTodo = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Todo追加ボタン（＋）押下時、Todo追加画面表示
            .sheet(isPresented: $isShowingAddTodo) {
                AddTodoView(viewModel: viewModel)
            }
            // Todoのタイトルテキスト押下時、Todo詳細画面表示
            .fullScreenCover(item: Binding<IdentifiableInt?>(
                get: { selectedTodoIndex.map { IdentifiableInt(id: $0) } },
                set: { selectedTodoIndex = $0?.id }
            )) { identifiableIndex in
                TodoTextView(viewModel: viewModel, index: identifiableIndex.id)
            }
        }
    }
}

// 画面遷移のためのラッパー
struct IdentifiableInt: Identifiable {
    let id: Int
}

#Preview {
    ContentView()
}

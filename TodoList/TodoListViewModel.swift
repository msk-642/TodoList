//
//  TodoListViewModel.swift
//  TodoList
//
//  Created by MSK on 2026/01/29.
//

import Combine
import SwiftUI

final class TodoListViewModel: ObservableObject {

    // プロパティ
    @Published private(set) var todos: [Todo] = []

    private let repository: TodoRepositoryProtocol

    // 初期化処理
    init(
        repository: TodoRepositoryProtocol = TodoRepository()
    ) {
        self.repository = repository
        self.todos = repository.load()
    }

    // ユーザーデフォルトストレージにTodoデータが存在しない時、APIからTodoを取得
    @MainActor
    func loadTodos() async {
        do {
            if todos.isEmpty {
                todos = try await repository.refresh()
            }
        } catch {
            print("エラー：¥(error)")
        }
    }

    // Todo追加処理
    func addTodo(title: String) {
        let newTodo = Todo(
            id: UUID(),
            title: title,
            isCompleted: false
        )
        todos.append(newTodo)
        repository.save(todos)
    }
    
    // Todoテキスト追加処理
    func addTodoText(_ text: String, at index: Int) {
        todos[index].text = text
        todos[index].updatedAt = Date()
        repository.save(todos)
    }

    // 削除処理
    func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        repository.save(todos)
    }

    // Todo完了トグル処理
    func toggleCompleted(at index: Int) {
        todos[index].isCompleted.toggle()
        repository.save(todos)
    }
}

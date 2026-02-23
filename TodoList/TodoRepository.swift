import Foundation

protocol TodoRepositoryProtocol {
    func load() -> [Todo]
    func refresh() async throws -> [Todo]
    func save(_ todos: [Todo])
}

final class TodoRepository: TodoRepositoryProtocol {

    private let api: TodoAPIProtocol
    private let storage: TodoStorageProtocol

    init(
        api: TodoAPIProtocol = TodoAPI(),
        storage: TodoStorageProtocol = UserDefaultsTodoStorage()
    ) {
        self.api = api
        self.storage = storage
    }

    func load() -> [Todo] {
        return storage.load()
    }

    func refresh() async throws -> [Todo] {
        let todos = try await api.fetchTodos()
        storage.save(todos)
        return todos
    }

    func save(_ todos: [Todo]) {
        storage.save(todos)
    }
}

import Foundation

protocol TodoStorageProtocol {
    func load() -> [Todo]
    func save(_ todos: [Todo])
}

final class UserDefaultsTodoStorage: TodoStorageProtocol {

    private let key = "todos"

    func load() -> [Todo] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let todos = try? JSONDecoder().decode([Todo].self, from: data)
        else {
            return []
        }
        return todos
    }

    func save(_ todos: [Todo]) {
        let data = try? JSONEncoder().encode(todos)
        UserDefaults.standard.set(data, forKey: key)
    }
}

import Foundation

protocol TodoAPIProtocol {
    func fetchTodos() async throws -> [Todo]
}

final class TodoAPI: TodoAPIProtocol {

    func fetchTodos() async throws -> [Todo] {
        // 疑似的な通信遅延
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // API通信が実装されるまでは空の配列を返す
        return []
    }
}

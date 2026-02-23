import XCTest
@testable import TodoList

final class TodoListViewModelTests: XCTestCase {
    
    private var viewModel: TodoListViewModel!
    private var mockRepository: MockTodoRepository!
    
    override func setUp() {
        super.setUp()
        // Repositoryのモックを作成し、ViewModelに注入する
        mockRepository = MockTodoRepository()
        viewModel = TodoListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testInitLoad() {
        // 初期化時にRepositoryのload()の結果がViewModelに反映されることを確認
        XCTAssertEqual(viewModel.todos.count, 1)
        XCTAssertEqual(viewModel.todos.first?.title, "Mock Init Todo")
    }
    
    func testAddTodo() {
        let initialCount = viewModel.todos.count
        
        let beforeAdd = Date()
        viewModel.addTodo(title: "テストTodo")
        
        // Todoの追加確認
        XCTAssertEqual(viewModel.todos.count, initialCount + 1)
        
        let addedTodo = viewModel.todos.last
        // 追加Todoのプロパティ値確認
        XCTAssertEqual(addedTodo?.title, "テストTodo")
        XCTAssertFalse(addedTodo?.isCompleted ?? true)
        
        // タイムスタンプの検証 (追加されたタイミングの時刻とほぼ等しいか)
        XCTAssertNotNil(addedTodo?.createdAt)
        XCTAssertNotNil(addedTodo?.updatedAt)
        XCTAssertEqual(addedTodo!.createdAt.timeIntervalSinceReferenceDate, beforeAdd.timeIntervalSinceReferenceDate, accuracy: 2.0)
        XCTAssertEqual(addedTodo!.updatedAt.timeIntervalSinceReferenceDate, beforeAdd.timeIntervalSinceReferenceDate, accuracy: 2.0)
        
        // Repositoryに現在のリストがSaveされているか確認
        XCTAssertEqual(mockRepository.todos.count, initialCount + 1)
    }
    
    func testAddTodoText() {
        // 初期Mockで作られるのは "Mock Init Todo" (index 0) 
        // -> 初期値として『1時間前』の時刻で設定されている
        let targetTodoBeforeUpdate = viewModel.todos[0]
        let originalCreatedAt = targetTodoBeforeUpdate.createdAt
        let originalUpdatedAt = targetTodoBeforeUpdate.updatedAt
        
        let beforeUpdate = Date()
        let newText = "追加テキスト"
        viewModel.addTodoText(newText, at: 0)
        
        let targetTodoAfterUpdate = viewModel.todos[0]
        
        // Todo詳細テキストが保存されているか確認
        XCTAssertEqual(targetTodoAfterUpdate.text, newText)
        XCTAssertEqual(mockRepository.todos[0].text, newText)
        
        // テキスト更新後、createdAtは元のまま変更されていないことを確認
        XCTAssertEqual(targetTodoAfterUpdate.createdAt, originalCreatedAt)
        // テキスト更新後、updatedAtが最新の時刻になっていることを確認
        XCTAssertNotEqual(targetTodoAfterUpdate.updatedAt, originalUpdatedAt)
        XCTAssertEqual(targetTodoAfterUpdate.updatedAt.timeIntervalSinceReferenceDate, beforeUpdate.timeIntervalSinceReferenceDate, accuracy: 2.0)
    }
    
    func testDeleteTodo() {
        viewModel.addTodo(title: "削除対象")
        let count = viewModel.todos.count
        
        // Index 1 (新しく追加した "削除対象") を削除する
        viewModel.deleteTodo(at: IndexSet(integer: 1))
        
        // 追加したTodoが削除されているか確認
        XCTAssertEqual(viewModel.todos.count, count - 1)
        XCTAssertEqual(mockRepository.todos.count, count - 1)
    }
    
    func testToggleCompleted() {
        // init段階の "Mock Init Todo" (index 0) は isCompleted = false
        XCTAssertFalse(viewModel.todos[0].isCompleted)
        
        viewModel.toggleCompleted(at: 0)
        // TodoのisCompleted更新確認（False → True）
        XCTAssertTrue(viewModel.todos[0].isCompleted)
        
        viewModel.toggleCompleted(at: 0)
        // TodoのisCompleted更新確認（True → False）
        XCTAssertFalse(viewModel.todos[0].isCompleted)
    }
    
    @MainActor
    func testLoadTodosWhenEmpty() async {
        // 空の状態で loadTodos を呼ぶと refresh() が走ることを確認する
        mockRepository.todos = [] // Mock内の状態を直接空にする
        // ViewModelを新しく作り直し、todosを空の状態で開始
        let emptyViewModel = TodoListViewModel(repository: mockRepository)
        
        XCTAssertTrue(emptyViewModel.todos.isEmpty)
        
        await emptyViewModel.loadTodos()
        
        // refreshのロジックが走り、返却された "Refreshed Todo" がセットされる
        XCTAssertEqual(emptyViewModel.todos.count, 1)
        XCTAssertEqual(emptyViewModel.todos.first?.title, "Refreshed Todo")
    }
}

final class MockTodoRepository: TodoRepositoryProtocol {
    // 時間経過の検証のため、初期データの作成・更新時間をわざと1時間前で作成しておく
    var todos: [Todo] = [
        Todo(
            id: UUID(),
            title: "Mock Init Todo",
            isCompleted: false,
            text: "",
            createdAt: Date().addingTimeInterval(-3600),
            updatedAt: Date().addingTimeInterval(-3600)
        )
    ]
    
    func load() -> [Todo] { 
        return todos 
    }
    
    func refresh() async throws -> [Todo] { 
        let refreshed = [Todo(id: UUID(), title: "Refreshed Todo", isCompleted: false)]
        // refresh()が呼ばれたら保存も更新されるという仮定
        self.todos = refreshed
        return refreshed
    }
    
    func save(_ todos: [Todo]) {
        self.todos = todos
    }
}

final class MockTodoStorage: TodoStorageProtocol {
    func load() -> [Todo] {
        return [
            Todo(id: UUID(), title: "storage load test", isCompleted: false)
        ]
    }
    
    func save(_ todos: [Todo]) {
        let data = try? JSONEncoder().encode(todos)
        UserDefaults.standard.set(data, forKey: "storage save test")
    }
}

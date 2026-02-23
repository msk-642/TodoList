//import SwiftUI
//
//struct TodoListView: View {
//
//    @StateObject private var viewModel = TodoListViewModel()
//    @State private var newTodoTitle = ""
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                HStack {
//                    TextField("新しいTodo", text: $newTodoTitle)
//                        .textFieldStyle(.roundedBorder)
//                    
//                    Button("追加") {
//                        guard !newTodoTitle.isEmpty else { return }
//                        viewModel.addTodo(title: newTodoTitle)
//                        newTodoTitle = ""
//                    }
//                }
//            }
//            .padding()
//            
//            List {
//                ForEach(viewModel.todos) { todo in
//                    TodoRowView(
//                        todo: todo,
//                        toggleAction: {
//                            viewModel.toggleCompleted(id: todo.id)
//                        }
//                    )
//                }
//                .onDelete { offsets in
//                    viewModel.deleteTodo(at: offsets)
//                }
//            }
//            .navigationTitle("TodoList")
//        }
//        .task {
//            await viewModel.loadTodos()
//        }
//    }
//}
//
//#Preview {
//    TodoListView()
//}

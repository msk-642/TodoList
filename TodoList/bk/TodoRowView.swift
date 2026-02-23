//import SwiftUI
//
//struct TodoRowView: View {
//
//    let todo: Todo
//    let toggleAction: () -> Void
//
//    var body: some View {
//        HStack {
//            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
//                .onTapGesture {
//                    toggleAction()
//                }
//
//            Text(todo.title)
//                .strikethrough(todo.isCompleted)
//        }
//    }
//}
//

//
//  TodoListApp.swift
//  TodoList
//
//  Created by MSK on 2026/01/29.
//

import SwiftUI
import CoreData

@main
struct TodoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
